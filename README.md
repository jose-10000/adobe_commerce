# adobe_commerce
Adobe Commerce Deployment


# Pre-requisites:
AWS user account with admin access, not a root account.
Cloud9 IDE with AWS CLI and Terraform.
Download the MySql GUI Tool. Based on your OS, select the respective option under Generally Available (GA) Releases, Download and Install.


# Erros


For "SQLSTATE[HY000]: General error: 1419 You do not have the SUPER privilege"
run in MySQL with root user
    set global log_bin_trust_function_creators=1;