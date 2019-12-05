data "aws_iam_policy_document" "codebuild" {
  statement {
    sid    = "CodeBuildDefaultPolicy"
    effect = "Allow"

    actions = [
      "codebuild:*",
      "iam:PassRole",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "CloudWatchLogsAccessPolicy"
    effect = "Allow"

    actions = [
      "logs:FilterLogEvents",
      "logs:GetLogEvents",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "S3AccessPolicy"
    effect = "Allow"

    actions = [
      "s3:CreateBucket",
      "s3:GetObject",
      "s3:List*",
      "s3:PutObject",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "S3BucketIdentity"
    effect = "Allow"

    actions = [
      "s3:GetBucketAcl",
      "s3:GetBucketLocation",
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "codebuild_service_role_policy" {
  statement {
    sid    = "CloudWatchLogsPolicy"
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "CodeCommitPolicy"
    effect = "Allow"

    actions = [
      "codecommit:GitPull",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "S3GetObjectPolicy"
    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "S3PutObjectPolicy"
    effect = "Allow"

    actions = [
      "s3:PutObject",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "ECRPullPolicy"
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "ECRAuthPolicy"
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "S3BucketIdentity"
    effect = "Allow"

    actions = [
      "s3:GetBucketAcl",
      "s3:GetBucketLocation",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "EKSActions"
    effect = "Allow"

    actions = [
      "eks:*",
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "k8s_pods_assume_role_policy" {
  statement {
    sid = "EKSWorkerAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com", "eks.amazonaws.com", "codebuild.amazonaws.com", "codepipeline.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "k8s_pods_policy" {
  statement {
    sid    = "eksWorkerAcm"
    effect = "Allow"

    actions = [
      "acm:DescribeCertificate",
      "acm:ListCertificates",
      "acm:GetCertificate",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "eksWorkerEc2"
    effect = "Allow"

    actions = [
      "ec2:AllocateAddress",
      "ec2:AssignPrivateIpAddresses",
      "ec2:Associate*",
      "ec2:AttachInternetGateway",
      "ec2:AttachNetworkInterface",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateDefaultSubnet",
      "ec2:CreateDhcpOptions",
      "ec2:CreateEgressOnlyInternetGateway",
      "ec2:CreateInternetGateway",
      "ec2:CreateLaunchTemplate",
      "ec2:CreateLaunchTemplateVersion",
      "ec2:CreateNatGateway",
      "ec2:CreateNetworkInterface",
      "ec2:CreateRoute",
      "ec2:CreateRouteTable",
      "ec2:CreateSecurityGroup",
      "ec2:CreateSubnet",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:CreateVpc",
      "ec2:DeleteDhcpOptions",
      "ec2:DeleteEgressOnlyInternetGateway",
      "ec2:DeleteInternetGateway",
      "ec2:DeleteLaunchTemplate",
      "ec2:DeleteLaunchTemplateVersions",
      "ec2:DeleteNatGateway",
      "ec2:DeleteNetworkInterface",
      "ec2:DeleteRoute",
      "ec2:DeleteRouteTable",
      "ec2:DeleteSecurityGroup",
      "ec2:DeleteSubnet",
      "ec2:DeleteTags",
      "ec2:DeleteVolume",
      "ec2:DeleteVpc",
      "ec2:DeleteVpnGateway",
      "ec2:Describe*",
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeAddresses",
      "ec2:DescribeInstanceStatus",
      "ec2:DescribeInstances",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeLaunchTemplateVersions",
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeNetworkInterfaceAttribute",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeRouteTables",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:DescribeVpcs",
      "ec2:DetachInternetGateway",
      "ec2:DetachNetworkInterface",
      "ec2:DetachVolume",
      "ec2:Disassociate*",
      "ec2:GetLaunchTemplateData",
      "ec2:ModifyInstanceAttribute",
      "ec2:ModifyLaunchTemplate",
      "ec2:ModifyNetworkInterfaceAttribute",
      "ec2:ModifySubnetAttribute",
      "ec2:ModifyVpcAttribute",
      "ec2:ModifyVpcEndpoint",
      "ec2:ReleaseAddress",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:RunInstances",
      "ec2:UpdateSecurityGroupRuleDescriptionsEgress",
      "ec2:UpdateSecurityGroupRuleDescriptionsIngress",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "eksWorkerELB"
    effect = "Allow"

    actions = [
      "cloudformation:*",
      "elasticloadbalancing:AddListenerCertificates",
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:CreateRule",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DeleteRule",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:DescribeListenerCertificates",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:DescribeSSLPolicies",
      "elasticloadbalancing:DescribeTags",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:ModifyRule",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:RemoveListenerCertificates",
      "elasticloadbalancing:RemoveTags",
      "elasticloadbalancing:SetIpAddressType",
      "elasticloadbalancing:SetSecurityGroups",
      "elasticloadbalancing:SetSubnets",
      "elasticloadbalancing:SetWebACL",
      "elasticloadbalancingv2:*",
      "elasticfilesystem:*",
    ]

    resources = [
      "*",
    ]
  }

  statement {
    sid    = "eksWorkerwIamService"
    effect = "Allow"

    actions = [
      "iam:AddRoleToInstanceProfile",
      "iam:AttachRolePolicy",
      "iam:CreateInstanceProfile",
      "iam:CreatePolicy",
      "iam:CreatePolicyVersion",
      "iam:CreateRole",
      "iam:CreateServiceLinkedRole",
      "iam:DeleteInstanceProfile",
      "iam:DeletePolicy",
      "iam:DeleteRole",
      "iam:DeleteRolePolicy",
      "iam:DeleteServiceLinkedRole",
      "iam:DetachRolePolicy",
      "iam:GetInstanceProfile",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:GetServerCertificate",
      "iam:List*",
      "iam:ListServerCertificates",
      "iam:PassRole",
      "iam:PutRolePolicy",
      "iam:RemoveRoleFromInstanceProfile",
      "iam:UpdateAssumeRolePolicy",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "eksWorkerUSerPool"
    effect = "Allow"

    actions = [
      "cognito-idp:DescribeUserPoolClient",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "eksWorkerWaf"
    effect = "Allow"

    actions = [
      "waf-regional:GetWebACLForResource",
      "waf-regional:GetWebACL",
      "waf-regional:AssociateWebACL",
      "waf-regional:DisassociateWebACL",
      "waf:GetWebACL",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "eksWorkerTag"
    effect = "Allow"

    actions = [
      "tag:GetResources",
      "tag:TagResources",
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "worker_external_dns" {
  statement {
    sid    = "eksWorkerExternalDns"
    effect = "Allow"

    actions = [
      "route53:GetChange",
      "route53:ChangeResourceRecordSets",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "eksWorkerExternalDnsCertManager"
    effect = "Allow"

    actions = [
      "route53:GetChange",
    ]

    resources = ["*"]
  }
  statement {
    sid    = "eksWorkerListDns"
    effect = "Allow"

    actions = [
      "route53:ListHostedZones",
      "route53:ListHostedZonesByName",
      "route53:ListResourceRecordSets",
    ]

    resources = ["*"]
  }
}

data "aws_iam_policy_document" "worker_autoscaling" {
  statement {
    sid    = "eksWorkerAutoscalingAll"
    effect = "Allow"

    actions = [
      "autoscaling:AttachInstances",
      "autoscaling:CreateAutoScalingGroup",
      "autoscaling:CreateLaunchConfiguration",
      "autoscaling:CreateOrUpdateTags",
      "autoscaling:DeleteAutoScalingGroup",
      "autoscaling:DeleteLaunchConfiguration",
      "autoscaling:DeleteTags",
      "autoscaling:Describe*",
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:DetachInstances",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:SuspendProcesses",
      "autoscaling:UpdateAutoScalingGroup",
      "ec2:DescribeLaunchTemplateVersions",
    ]

    resources = ["*"]
  }

  statement {
    sid    = "eksWorkerAutoscalingOwn"
    effect = "Allow"

    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "autoscaling:UpdateAutoScalingGroup",
      "autoscaling:AttachLoadBalancers",
      "autoscaling:DetachLoadBalancers",
      "autoscaling:DetachLoadBalancerTargetGroups",
      "autoscaling:AttachLoadBalancerTargetGroups",
      "autoscaling:DescribeLoadBalancerTargetGroups",
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "autoscaling:ResourceTag/kubernetes.io/cluster/${var.eks_cluster_name}"
      values   = ["owned", "shared"]
    }

    condition {
      test     = "StringEquals"
      variable = "autoscaling:ResourceTag/k8s.io/cluster-autoscaler/enabled"
      values   = ["true"]
    }
  }
}
