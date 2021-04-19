resource "aws_kms_key" "this" {
  count               = var.flux_sops_kms_create ? 1 : 0
  description         = "${var.flux_sops_kms_name} key"
  enable_key_rotation = true
  key_usage           = "ENCRYPT_DECRYPT"
}

resource "aws_kms_grant" "grants-rw" {
  count             = length(var.flux_sops_kms_additional_principals_rw)
  grantee_principal = var.flux_sops_kms_additional_principals_rw[count.index]
  key_id            = aws_kms_key.this.key_id
  operations        = ["Decrypt", "Encrypt"]
}

resource "aws_kms_grant" "grants-ro" {
  count             = length(var.flux_sops_kms_additional_principals_ro)
  grantee_principal = var.flux_sops_kms_additional_principals_ro[count.index]
  key_id            = aws_kms_key.this.key_id
  operations        = ["Decrypt"]
}

resource "aws_kms_alias" "this" {
  count         = var.flux_sops_kms_create ? 1 : 0
  name          = "alias/${var.flux_sops_kms_name}"
  target_key_id = aws_kms_key.this.key_id
}

data "aws_iam_policy_document" "flux2_kms_sts" {


  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]

    }
    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.this.id}:oidc-provider/${local.oidc_id}"]

    }
    condition {
      test     = "StringEquals"
      variable = "${local.oidc_id}:aud"
      values = [
        "sts.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "flux2_kms_role" {
  count              = var.flux_sops_kms_create ? 1 : 0
  name               = "${var.flux_sops_kms_name}-flux2_sts"
  assume_role_policy = data.aws_iam_policy_document.flux2_kms_sts.json
}

resource "aws_iam_policy" "flux2_kms_ro" {
  count       = var.flux_sops_kms_create ? 1 : 0
  name_prefix = "${var.flux_sops_kms_name}-flux2_ro"
  policy      = data.aws_iam_policy_document.flux2_kms_ro.json
}

resource "aws_iam_policy" "flux2_kms_rw" {
  count       = var.flux_sops_kms_create ? 1 : 0
  name_prefix = "${var.flux_sops_kms_name}-flux2_rw"
  policy      = data.aws_iam_policy_document.flux2_kms_rw.json
}

data "aws_iam_policy_document" "flux2_kms_rw" {
  statement {
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = [
      aws_kms_key.this.arn,
    ]
  }
}
