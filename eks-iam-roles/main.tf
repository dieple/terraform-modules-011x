# cluster IAM role
resource "aws_iam_role" "cluster" {
  name                  = "eks-cluster-role-${var.stage}"
  assume_role_policy    = "${data.aws_iam_policy_document.cluster_assume_role_policy.json}"
  permissions_boundary  = "${var.permissions_boundary}"
  path                  = "${var.iam_path}"
  force_detach_policies = true
}

## Workers IAM role
resource "aws_iam_role" "k8s_pods_iam_role" {
  name                  = "eks-workers-iam-role-${var.stage}"
  assume_role_policy    = "${data.aws_iam_policy_document.k8s_pods_assume_role_policy.json}"
  permissions_boundary  = "${var.permissions_boundary}"
  path                  = "${var.iam_path}"
  force_detach_policies = true
}

## CodeDeploy IAM role
resource "aws_iam_role" "codebuild_iam_role" {
  name                  = "CodeBuildServiceRole"
  assume_role_policy    = "${data.aws_iam_policy_document.k8s_pods_assume_role_policy.json}"
  permissions_boundary  = "${var.permissions_boundary}"
  path                  = "${var.iam_path}"
  force_detach_policies = true
}

resource "aws_iam_instance_profile" "workers" {
  name = "eks-workers-instance-profile-${var.stage}"
  role = "${aws_iam_role.k8s_pods_iam_role.id}"

  path = "${var.iam_path}"
}

resource "aws_iam_policy" "k8s_pods_iam_policy" {
  name        = "k8s-pods-${var.stage}"
  description = "EKS pods policy for cluster"
  policy      = "${data.aws_iam_policy_document.k8s_pods_policy.json}"
  path        = "${var.iam_path}"
}

resource "aws_iam_policy" "codebuild_policy" {
  name        = "cicd-codebuild-${var.stage}"
  description = "EKS codebuild policy for cluster"
  policy      = "${data.aws_iam_policy_document.codebuild.json}"
  path        = "${var.iam_path}"
}

resource "aws_iam_policy" "worker_autoscaling" {
  name        = "eks-worker-autoscaling-${var.stage}"
  description = "EKS worker node autoscaling policy for cluster"
  policy      = "${data.aws_iam_policy_document.worker_autoscaling.json}"
  path        = "${var.iam_path}"
}

resource "aws_iam_policy" "route53_external_dns" {
  name        = "eks-worker-external-dns-${var.stage}"
  description = "EKS worker node external dns policy for cluster"
  policy      = "${data.aws_iam_policy_document.worker_external_dns.json}"
  path        = "${var.iam_path}"
}

resource "aws_iam_policy" "codebuild_service_role_policy" {
  name        = "CodeBuildServiceRolePolicy"
  description = "codebuild service role policy to interact with other services"
  policy      = "${data.aws_iam_policy_document.codebuild_service_role_policy.json}"
  path        = "${var.iam_path}"
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.cluster.name}"
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.cluster.name}"
}

resource "aws_iam_role_policy_attachment" "k8s_codebuild" {
  policy_arn = "${aws_iam_policy.codebuild_policy.arn}"
  role       = "${aws_iam_role.k8s_pods_iam_role.name}"
}

resource "aws_iam_role_policy_attachment" "k8s_pods" {
  policy_arn = "${aws_iam_policy.k8s_pods_iam_policy.arn}"
  role       = "${aws_iam_role.k8s_pods_iam_role.name}"
}

resource "aws_iam_role_policy_attachment" "workers_workers_dns" {
  policy_arn = "${aws_iam_policy.route53_external_dns.arn}"
  role       = "${aws_iam_role.k8s_pods_iam_role.name}"
}

resource "aws_iam_role_policy_attachment" "pods_workers_autoscaling" {
  policy_arn = "${aws_iam_policy.worker_autoscaling.arn}"
  role       = "${aws_iam_role.k8s_pods_iam_role.name}"
}

resource "aws_iam_role_policy_attachment" "pods_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.k8s_pods_iam_role.name}"
}

resource "aws_iam_role_policy_attachment" "pods_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.k8s_pods_iam_role.name}"
}

resource "aws_iam_role_policy_attachment" "pods_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.k8s_pods_iam_role.name}"
}

resource "aws_iam_role_policy_attachment" "pods_AmazonContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.k8s_pods_iam_role.name}"
}

resource "aws_iam_role_policy_attachment" "pods_AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.k8s_pods_iam_role.name}"
}

resource "aws_iam_role_policy_attachment" "pods_AmazonCodeBuildServicePolicy" {
  policy_arn = "${aws_iam_policy.codebuild_service_role_policy.arn}"
  role       = "${aws_iam_role.k8s_pods_iam_role.name}"
}

resource "aws_iam_role_policy_attachment" "CodeBuildServicePolicy" {
  policy_arn = "${aws_iam_policy.codebuild_service_role_policy.arn}"
  role       = "${aws_iam_role.codebuild_iam_role.name}"
}
