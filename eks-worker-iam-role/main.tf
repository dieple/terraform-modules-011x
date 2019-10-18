## Workers IAM role
resource "aws_iam_role" "k8s_pods_iam_role" {
  name                  = "${var.role_name}"
  assume_role_policy    = "${data.aws_iam_policy_document.k8s_pods_assume_role_policy.json}"
  permissions_boundary  = "${var.permissions_boundary}"
  path                  = "${var.iam_path}"
  force_detach_policies = true
  tags                  = "${var.tags}"
}

resource "aws_iam_instance_profile" "workers" {
  name = "${var.role_name}-instance-profile"
  role = "${aws_iam_role.k8s_pods_iam_role.id}"

  path = "${var.iam_path}"
}

resource "aws_iam_policy" "k8s_pods_iam_policy" {
  name        = "${var.role_name}-k8s-pods-policy"
  description = "EKS pods policy for cluster"
  policy      = "${data.aws_iam_policy_document.k8s_pods_policy.json}"
  path        = "${var.iam_path}"
}

resource "aws_iam_policy" "codebuild_policy" {
  name        = "${var.role_name}-codebuild-policy"
  description = "EKS codebuild policy for cluster"
  policy      = "${data.aws_iam_policy_document.codebuild.json}"
  path        = "${var.iam_path}"
}

resource "aws_iam_policy" "worker_autoscaling" {
  name        = "${var.role_name}-autoscaling-policy"
  description = "EKS worker node autoscaling policy for cluster"
  policy      = "${data.aws_iam_policy_document.worker_autoscaling.json}"
  path        = "${var.iam_path}"
}

resource "aws_iam_policy" "route53_external_dns" {
  name        = "${var.role_name}-external-dns-policy"
  description = "EKS worker node external dns policy for cluster"
  policy      = "${data.aws_iam_policy_document.worker_external_dns.json}"
  path        = "${var.iam_path}"
}

resource "aws_iam_policy" "codebuild_service_role_policy" {
  name        = "${var.role_name}-code-build-service-policy"
  description = "codebuild service role policy to interact with other services"
  policy      = "${data.aws_iam_policy_document.codebuild_service_role_policy.json}"
  path        = "${var.iam_path}"
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
