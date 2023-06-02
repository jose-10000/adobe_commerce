# Go to https://<Rancher-Server-IP> and login with default password
# For the first time, it will ask to put the password and then it will ask to create a new password.
# Ussing SSH, login to the server and run the following command to get the password. Then copy the password and paste it to the Rancher login page.

 CONTAINERID=$(docker ps | grep "rancher/rancher" | awk '{print $1}' | xargs)  # This will give you the container id and put it to the variable CONTAINERID
 sudo docker logs $CONTAINERID 2>&1 | grep "Bootstrap Password"


# Add bitnami repo to Rancher
  # Menu > Cluster Management > Advanced > Repositories > Create
  # Name: bitnami
  # URL: https://charts.bitnami.com/bitnami




### Creating a k8s cluster using rancher
# Before you start with this, make sure, that you meet these requirements:
# Rancher needs permission to create and manage AWS resources on your behalf. To do this, you need to create an IAM user with the following permissions:

# Go to IAM in the AWS console and create a new user
# Then we are going to create 3 policies, go to policies and create a new policy with the following permissions:

#rancher-controlplane-policy

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ec2:AttachVolume",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:DescribeInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "ec2:DescribeRegions",
                "elasticloadbalancing:DescribeLoadBalancerPolicyTypes",
                "elasticloadbalancing:SetWebAcl",
                "elasticloadbalancing:DescribeLoadBalancers",
                "ec2:DeleteVolume",
                "elasticloadbalancing:DescribeListeners",
                "autoscaling:DescribeAutoScalingGroups",
                "ec2:CreateRoute",
                "ec2:CreateSecurityGroup",
                "ec2:DescribeVolumes",
                "elasticloadbalancing:DescribeLoadBalancerPolicies",
                "kms:DescribeKey",
                "elasticloadbalancing:DescribeListenerCertificates",
                "elasticloadbalancing:DescribeInstanceHealth",
                "ec2:ModifyInstanceAttribute",
                "ec2:DescribeRouteTables",
                "elasticloadbalancing:DescribeSSLPolicies",
                "ec2:DetachVolume",
                "ec2:ModifyVolume",
                "ec2:CreateTags",
                "autoscaling:DescribeTags",
                "ec2:DeleteRoute",
                "elasticloadbalancing:*",
                "ec2:DescribeSecurityGroups",
                "ec2:CreateVolume",
                "elasticloadbalancing:DescribeLoadBalancerAttributes",
                "ec2:RevokeSecurityGroupIngress",
                "iam:CreateServiceLinkedRole",
                "elasticloadbalancing:DescribeTargetGroupAttributes",
                "ec2:DescribeVpcs",
                "elasticloadbalancing:DescribeAccountLimits",
                "ec2:DeleteSecurityGroup",
                "elasticloadbalancing:DescribeTargetHealth",
                "elasticloadbalancing:DescribeTargetGroups",
                "elasticloadbalancing:DescribeRules",
                "ec2:DescribeSubnets"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "elasticloadbalancing:*",
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor2",
            "Effect": "Allow",
            "Action": "elasticloadbalancing:*",
            "Resource": "arn:aws:elasticloadbalancing:*:[YOUR_AWS_ACCOUNT_ID]:loadbalancer/*"
        },
        {
            "Sid": "VisualEditor3",
            "Effect": "Allow",
            "Action": "elasticloadbalancing:*",
            "Resource": [
                "arn:aws:elasticloadbalancing:*:[YOUR_AWS_ACCOUNT_ID]:targetgroup/*/*",
                "arn:aws:elasticloadbalancing:*:[YOUR_AWS_ACCOUNT_ID]:listener-rule/app/*/*/*/*",
                "arn:aws:elasticloadbalancing:*:[YOUR_AWS_ACCOUNT_ID]:listener-rule/net/*/*/*/*",
                "arn:aws:elasticloadbalancing:*:[YOUR_AWS_ACCOUNT_ID]:listener/net/*/*/*",
                "arn:aws:elasticloadbalancing:*:[YOUR_AWS_ACCOUNT_ID]:listener/app/*/*/*",
                "arn:aws:elasticloadbalancing:*:[YOUR_AWS_ACCOUNT_ID]:loadbalancer/net/*/*",
                "arn:aws:elasticloadbalancing:*:[YOUR_AWS_ACCOUNT_ID]:loadbalancer/app/*/*"
            ]
        },
        {
            "Sid": "VisualEditor4",
            "Effect": "Allow",
            "Action": "elasticloadbalancing:*",
            "Resource": [
                "arn:aws:elasticloadbalancing:*:[YOUR_AWS_ACCOUNT_ID]:targetgroup/*/*",
                "arn:aws:elasticloadbalancing:*:[YOUR_AWS_ACCOUNT_ID]:listener-rule/app/*/*/*/*",
                "arn:aws:elasticloadbalancing:*:[YOUR_AWS_ACCOUNT_ID]:listener-rule/net/*/*/*/*",
                "arn:aws:elasticloadbalancing:*:[YOUR_AWS_ACCOUNT_ID]:listener/net/*/*/*",
                "arn:aws:elasticloadbalancing:*:[YOUR_AWS_ACCOUNT_ID]:listener/app/*/*/*",
                "arn:aws:elasticloadbalancing:*:[YOUR_AWS_ACCOUNT_ID]:loadbalancer/net/*/*",
                "arn:aws:elasticloadbalancing:*:[YOUR_AWS_ACCOUNT_ID]:loadbalancer/app/*/*"
            ]
        },
        {
            "Sid": "VisualEditor5",
            "Effect": "Allow",
            "Action": "elasticloadbalancing:*",
            "Resource": [
                "arn:aws:elasticloadbalancing:*:[YOUR_AWS_ACCOUNT_ID]:loadbalancer/app/*/*",
                "arn:aws:elasticloadbalancing:*:[YOUR_AWS_ACCOUNT_ID]:loadbalancer/net/*/*",
                "arn:aws:elasticloadbalancing:*:[YOUR_AWS_ACCOUNT_ID]:targetgroup/*/*",
                "arn:aws:elasticloadbalancing:*:[YOUR_AWS_ACCOUNT_ID]:listener-rule/app/*/*/*/*",
                "arn:aws:elasticloadbalancing:*:[YOUR_AWS_ACCOUNT_ID]:listener-rule/net/*/*/*/*",
                "arn:aws:elasticloadbalancing:*:[YOUR_AWS_ACCOUNT_ID]:listener/net/*/*/*",
                "arn:aws:elasticloadbalancing:*:[YOUR_AWS_ACCOUNT_ID]:listener/app/*/*/*"
            ]
        }
    ]
}

#rancher-etcd-worker-policy
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "ec2:*",
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "secretsmanager:*",
            "Resource": "arn:aws:secretsmanager:*:[YOUR_AWS_ACCOUNT_ID]:secret:*"
        }
    ]
}

#rancher-passrole-policy
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ec2:ModifyInstanceMetadataOptions",
                "ec2:AuthorizeSecurityGroupIngress",
                "ec2:Describe*",
                "ec2:ImportKeyPair",
                "ec2:CreateKeyPair",
                "ec2:CreateSecurityGroup",
                "ec2:CreateTags",
                "eks:*",
                "ec2:DeleteKeyPair"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "ec2:RunInstances",
            "Resource": [
                "arn:aws:ec2:eu-central-1::image/ami-*",
                "arn:aws:ec2:eu-central-1:[YOUR_AWS_ACCOUNT_ID]:security-group/*",
                "arn:aws:ec2:eu-central-1:[YOUR_AWS_ACCOUNT_ID]:subnet/*",
                "arn:aws:ec2:eu-central-1:[YOUR_AWS_ACCOUNT_ID]:network-interface/*",
                "arn:aws:iam::[YOUR_AWS_ACCOUNT_ID]:role/rancher-controlpane-role",
                "arn:aws:iam::[YOUR_AWS_ACCOUNT_ID]:role/rancher-etcd-worker-role",
                "arn:aws:ec2:eu-central-1:[YOUR_AWS_ACCOUNT_ID]:instance/*",
                "arn:aws:ec2:eu-central-1:[YOUR_AWS_ACCOUNT_ID]:volume/*",
                "arn:aws:ec2:eu-central-1:[YOUR_AWS_ACCOUNT_ID]:placement-group/*",
                "arn:aws:ec2:eu-central-1:[YOUR_AWS_ACCOUNT_ID]:key-pair/*"
            ]
        },
        {
            "Sid": "VisualEditor2",
            "Effect": "Allow",
            "Action": [
                "ec2:RebootInstances",
                "ec2:TerminateInstances",
                "ec2:StartInstances",
                "ec2:StopInstances"
            ],
            "Resource": "arn:aws:ec2:eu-central-1:[YOUR_AWS_ACCOUNT_ID]:instance/*"
        },
        {
            "Sid": "VisualEditor3",
            "Effect": "Allow",
            "Action": "iam:PassRole",
            "Resource": [
                "arn:aws:iam::[YOUR_AWS_ACCOUNT_ID]:role/rancher-controlpane-role",
                "arn:aws:iam::[YOUR_AWS_ACCOUNT_ID]:role/rancher-etcd-worker-role"
            ]
        }
    ]
}

# Now create two IAM roles with the following policies:
    # 1. rancher-controlpane-role
    # 2. rancher-etcd-worker-role

# Atach the "rancher-controlpane-role" to a new user or to an existing user, use the AWS Access Key ID and Secret Key ID of this user to add the credentials to Rancher.

# Add AWS Credentials to Rancher, you need to create an IAM user with the following permissions:
  
  # Menu > Cluster Management > Cloud Credentials > Create > Amazon
  # Name: AWS
  # Access Key ID: <AWS Access Key ID>
  # Secret Key ID: <AWS Secret Key ID>
  # Default Region: <AWS Region>
  # Click on Create

# Generate Templates
    # Menu > Cluster Management > RKE1 Configuration > Nodes Templates > Add Node Template > Amazon EC2
    
    # We will create 3 templates:
        # 1. Control Plane
        # 2. Etcd
        # 3. Worker 

    # 1. Control Plane
        # 1.1. Account Access
            # Region: <AWS Region>   
            # Cloud Credential: The one you created in the previous step
            # Next

        # 1.2. Zone and Network
            # VPC: <VPC ID>
            # Subnet: <Subnet ID>
            # Availability Zone: <Availability Zone>
            # Next
        # 1.3. Security Groups
            # Select "Standard: Automatically create a rancher-nodes group"
            # Next
        # 1.4. Instance
            # Name: controlplane
            # IAM Instance Profile Name: rancher-controlplane-role
            # Instance Type: t3.large
            # Disk Size: 
            # AMI: ami-0d31449d0dd5f363f #### Debian 11 eu-west-1
            # SSH User: admin
            # Next
    
    # 2. Etcd
        # 2.1. Account Access
            # Region: <AWS Region>   
            # Cloud Credential: The one you created in the previous step
            # Next
        # 2.2. Zone and Network
            # VPC: <VPC ID>
            # Subnet: <Subnet ID>
            # Availability Zone: <Availability Zone>
            # Next
        # 2.3. Security Groups
            # Select "Standard: Automatically create a rancher-nodes group"
            # Next
        # 2.4. Instance
            # Name: etcd
            # IAM Instance Profile Name: rancher-etcd-worker-role
            # Instance Type: t3.large
            # Disk Size: 
            # AMI: ami-0d31449d0dd5f363f #### Debian 11 eu-west-1
            # SSH User: admin
            # Next

    # 3. Worker
        # 3.1. Account Access
            # Region: <AWS Region>   
            # Cloud Credential: The one you created in the previous step
            # Next
        # 3.2. Zone and Network
            # VPC: <VPC ID>
            # Subnet: <Subnet ID>
            # Availability Zone: <Availability Zone>
            # Next
        # 3.3. Security Groups
            # Select "Standard: Automatically create a rancher-nodes group"
            # Next
        # 3.4. Instance
            # Name: worker
            # IAM Instance Profile Name: rancher-etcd-worker-role
            # Instance Type: t3.large
            # Disk Size: 
            # AMI: ami-0d31449d0dd5f363f #### Debian 11 eu-west-1
            # SSH User: admin
            # Next


# Create a Cluster
    # Menu > Cluster Management > Clusters > Create > Amazon EC2
        # Provision new nodes and create a cluster using RKE 1.x
    
    # 1. Cluster Name
        # Name: cluster1
    
    
    # 2. Add node Pool, Select the 3 templates you created in the previous step
        # Node Pool Name: controlplane
        # Node Template: controlplane
        # Node Role: Control Plane
        # Node Quantity: 1

        # Node Pool Name: etcd
        # Node Template: etcd
        # Node Role: Etcd
        # Node Quantity: 1

        # Node Pool Name: worker
        # Node Template: worker
        # Node Role: Worker
        # Node Quantity: 1

    # 2. Cluster Options
        # Kubernetes Version: v1.24.13-rancher2-1
        # Next

    # 3. Network provider
        # Select "Canal"

    # 4. Cloud Provider
        # Select "Amazon (In-Tree)"
    
    # 5. Create

# Wait for the cluster to be created

# Access the cluster
    # Menu > Cluster Management > Clusters > cluster1 > Kubeconfig File > Download Config File

    # Copy the content of the file to ~/.kube/config

    # kubectl get nodes


# Now install Magento2

# In a terminal run the following commands:

#############Rancher Local Path Provisioner ##########################

kubectl apply -f https://raw.githubusercontent.com/rancher/local-path-provisioner/master/deploy/local-path-storage.yaml
kubectl patch storageclass local-path -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

#############Magento2##########################

helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update
helm install my-release oci://registry-1.docker.io/bitnamicharts/magento

# Wait for the installation to finish and then run the following commands to environment variables:

export APP_HOST=$(kubectl get svc --namespace default my-release-magento --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
export APP_PASSWORD=$(kubectl get secret --namespace default my-release-magento -o jsonpath="{.data.magento-password}" | base64 -d)
export DATABASE_ROOT_PASSWORD=$(kubectl get secret --namespace default my-release-mariadb -o jsonpath="{.data.mariadb-root-password}" | base64 -d)
export APP_DATABASE_PASSWORD=$(kubectl get secret --namespace default my-release-mariadb -o jsonpath="{.data.mariadb-password}" | base64 -d)

check the values of the variables:

echo $APP_HOST
echo $APP_PASSWORD
echo $DATABASE_ROOT_PASSWORD
echo $APP_DATABASE_PASSWORD



helm upgrade --namespace default my-release oci://registry-1.docker.io/bitnamicharts/magento \
    --set magentoHost=$APP_HOST,magentoPassword=$APP_PASSWORD,mariadb.auth.rootPassword=$DATABASE_ROOT_PASSWORD,mariadb.auth.password=$APP_DATABASE_PASSWORD

# Access Magento2

# Intall cron job
# bin/magento cron:install --force # use --force to rewrite existing cron job
echo $APP_HOST # Get the IP of the load balancer
curl -I $APP_HOST # Check the status code of the response

# Install sample data
# bin/magento sampledata:deploy
# Go to the pod and run the following commands:
    # kubectl exec -it my-release-magento-7f9f4f7d4f-4q9q8 -- /bin/bash
    # cd /bitnami/magento
    #
bin/magento setup:perf:generate-fixtures /bitnami/magento/setup/performance-toolkit/profiles/ce/small.xml

# For upgrading Magento2 values, run the following command:

helm upgrade -f values.yaml --namespace default my-release oci://registry-1.docker.io/bitnamicharts/magento \
    --set magentoHost=$APP_HOST,magentoPassword=$APP_PASSWORD,mariadb.auth.rootPassword=$DATABASE_ROOT_PASSWORD,mariadb.auth.password=$APP_DATABASE_PASSWORD

# For HPAs, run the following command:

# First, enable the metrics server:

# With kubectl:
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml


# With helm:
helm install metrics-server bitnami/metrics-server


kubectl autoscale deployment my-release-magento --namespace default --cpu-percent=50 --min=1 --max=5



# For testing with siege, run the following command:

siege -c 100 -t 1m $APP_HOST

# For testing with ab, run the following command:

ab -n 1000 -c 100 $APP_HOST

# For testing with wrk, run the following command:

wrk -t 10 -c 100 -d 1m $APP_HOST


# Scale down the deployment:

kubectl scale deployment my-release-magento --namespace default --replicas=1