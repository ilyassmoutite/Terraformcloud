# Infrastructure as code for Magento 2 Cloud Architecture on AWS

This repository contains Magento 2 Cloud Terraform infrastructure as code for AWS Public Cloud

This Infrastructure is the result of years of experience scaling Magento 1 and 2 in the cloud. It comes with the best practises baked right in saving your business time and money and customers.

Leverage your own AWS Account dramatically to reduce your monthly spend instead of paying an expensive managed hosting provider (PaaS, SaaS).

## Enterprise Support/Installation/Development Package available.
Several Magento development Agencies select this custom cloud solution for their clients and they are willing to provide services for businesses based on this Open Source project.
Nowerday this project has 6 partners (2 USA (California), 1 Poland, 2 Ukraine, 1 Pakistan). List will be soon, now you can  send me an email for contacts.
If you are willing to be listed as cloud service provider feel free message me.


More information: yegorshytikov@gmail.com

I also Have Ansible Magento Clout provisioning implementation:
https://github.com/Genaker/AWS_Magento2_Ansible

## AWS Magento 2 Cloud Features:
* True Horizontal Auto Scaling 
* Affordable(starting from ~300$ for us-west-2 region)
* MySQL RDS scalable Managed by Amazon, multi az failover, vertical scaling without downtime
* Compatible with RDS Aurora Cluster and Aurora Serverless
* EFS - Fully managed elastic NFS for media and configuration storage
* CloudFront CDN for static and media served from different origins S3 or Magento(EFS) as second origin 
* Automatically back (point-in-time snapshot) up your code and databases for easy restoration.
* 99.9 Uptime, multi az high availability 
* High security (Security groups, private infrastructure)
* Network Address Translation (NAT) has Elastic(Static) IP and used for internet access for all EC2 instances.
* Bastion host to provide Secure Shell (SSH) access to the Magento web servers. 
* Appropriate security groups for each instance or function to restrict access to only necessary protocols and ports.
* Private Public Subnets - NAT gateway, Bastion server
* All servers and Database are hosted in private Network securely
* System and Software Update Patches
* DDoS Protection with AWS Shield
* PCI compliant infrastructure
* Redis cluster
* Amazon Elasticsearch Service - Elasticsearch at scale with zero down time with built-in Kibana
* Different Application Scaling Groups (ASG)
* Application Load Balancer(ALB) with SSL/TSL termination, SSL certificates management
* ALB Path-Based Routing, Host-Based Routing, Lambda functions as targets, HTTP header/method-based routing, Query string parameter-based routing 		
* Scaled Varnish ASG
* Dedicated Admin/Cron ASG
* You can easily add new autoscaling groups for you needs (Per WebSite/for Checkout requests/for API), just copy paste code 
* Possibility to run the same infrastructure on Production/Staging/Dev environment, different projects
* Automatic CI/CD (CodePipeline/CodeDeploy) deployments possible
* AWS CodeDeploy In-place deployment, Blue/green deployment form Git or S3, Redeploy or Roll Back
* Deploying from a Development Account to a Production Account
* Amazon Simple Email Service (Amazon SES) - cloud-based email sending service. Price $0.10 for 1K emails 
* Amazon CloudWatch - load all the metrics (CPU, RAM, Network) in your account for search, graphing, and alarms. Metric data is kept for 15 months.
* CloudWatch alarms that watches a single CloudWatch metric or the result of a math expression based on CloudWatch metrics and send SMS(Text) Notifications or Emails
* Simple and Step Scaling Policies - choose scaling metrics that trigger horizontal scaling.
* Manual Scaling for Magento Auto Scaling Group (ASG)
* AWS Command Line Interface (CLI) - tool to manage your AWS services. You can control multiple AWS services from the command line and automate them through scripts.
* DynamoDb for logs, indexes, analytics
* Lambda functions as targets for a load balancer
* Elastic Container Registry (ECR) - fully-managed Docker container registry that makes it easy to store, manage, and deploy Docker container images!
* You can use Amazon Elastic Container Service (ECS) instead of ASG with Service Auto Scaling to adjust running containers desired count automatically.
* Awesome AWS documentation is Open Source and on GitHub

![Magento 2 AWS Infrastructure Cloud ](https://github.com/Genaker/TerraformMagentoCloud/blob/master/Magento2Cloud.png)

[Cloud Flat View](https://github.com/Genaker/TerraformMagentoCloud/blob/master/Magento2Cloud-Flat.png)

# Running and Scaling Magento on AWS (Video)
[![Magento AWS Cloud](https://img.youtube.com/vi/0hVymqegs9Y/0.jpg)](https://www.youtube.com/watch?v=0hVymqegs9Y)

Architecting your Magento platform to grow with your business can sometimes be a challenge. This video walks through the steps needed to take an out-of-the-box, single-node Magento implementation and turn it into a highly available, elastic, and robust deployment. This includes an end-to-end caching strategy that provides an efficient front-end cache (including populated shopping carts) using Varnish on Amazon EC2 as well as offloading the Magento caches to separate infrastructure such as Amazon ElastiCache. We also look at strategies to manage the Magento Media library outside of the application instances, including EC2-based shared storage solutions and Amazon S3. At the data layer we look at Magento-specific Amazon RDS-tuning strategies including configuring Magento to use read replicas for horizontal scalability.

# Our Infrastructure

Infrastructure consists of multiple layers (autoscaling, alb, rds, security-group, vpc) where each layer is configured using one of [Terraform AWS modules](https://github.com/terraform-aws-modules/) with arguments specified in `terraform.tfvars` in layer's directory.

Terraform use the SSH protocol to clone the modules, configured SSH keys will be used automatically. Add SSH key to github account. (https://help.github.com/en/enterprise/2.15/user/articles/adding-a-new-ssh-key-to-your-github-account)

Terraform uses this during the module installation step of terraform init to download the source code to a directory on local disk so that it can be used by other Terraform commands.

[Terragrunt](https://github.com/gruntwork-io/terragrunt) is used to work with Terraform configurations which allows to orchestrate dependent layers, update arguments dynamically and keep configurations. Dfine Terraform code once, no matter how many environments you have.   [DRY]
(https://en.wikipedia.org/wiki/Don%27t_repeat_yourself).

## Pre-requirements

- [Terraform 0.12 or newer](https://www.terraform.io/)
- [Terragrunt 0.19 or newer](https://github.com/gruntwork-io/terragrunt)
- [tfvars-annotations](https://github.com/antonbabenko/tfvars-annotations) - Update values in terraform.tfvars using annotations
- Optional: [pre-commit hooks](http://pre-commit.com) to keep Terraform formatting and documentation up-to-date

If you are using Mac you can install all dependencies using Homebrew:

    $ brew install terraform terragrunt pre-commit

By default, access credentials to AWS account should be set using environment variables:

    $ export AWS_DEFAULT_REGION=us-west-1
    $ export AWS_ACCESS_KEY_ID=...
    $ export AWS_SECRET_ACCESS_KEY=...

Alternatively, you can edit `common/main_providers.tf` and use another authentication mechanism as described in [AWS provider documentation](https://www.terraform.io/docs/providers/aws/index.html#authentication).



## How to use it?

First, you should run `chmod +x common/scripts/update_dynamic_values_in_tfvars.sh`, review and specify all required arguments for each layer. Run this to see all errors:

    $ terragrunt validate-all --terragrunt-ignore-dependency-errors |& grep -C 3 "Error: "

Once all arguments are set, run this command to create infrastructure in all layers in a single region:

    $ cd production
    $ terragrunt apply-all

Alternatively, you can create infrastructure in a single layer (eg, `autoscaling_3`):

    $ cd production/autoscaling_3
    $ terragrunt apply

See [official Terragrunt documentation](https://github.com/gruntwork-io/terragrunt/blob/master/README.md) for all available commands and features.


# Approximate Magento 2 AWS Cloud infrastructure Cost

```
+-------------+---------------------+-----------+------------+-------+------------+---------------+---------------+
| Category    | Type                | Region    | Total cost | Count | Unit price | Instance type | Instance size |
+-------------+---------------------+-----------+------------+-------+------------+---------------+---------------+
| appservices | Email Service - 10K | us-west-2 | $1.00      | 1     | $1.00      |               |               |
+-------------+---------------------+-----------+------------+-------+------------+---------------+---------------+
| storage     | EFS storage – 20GB  | us-west-2 | $6.00      | 1     | $6.00      |               |               |
+-------------+---------------------+-----------+------------+-------+------------+---------------+---------------+
| storage     | S3 – 50Gb           | us-west-2 | $2.00      | 1     | $2.00      |               |               |
+-------------+---------------------+-----------+------------+-------+------------+---------------+---------------+
| compute     | ec2-Web Node        | us-west-2 | $61.20     | 1     | $61.20     | c5            | large         |
+-------------+---------------------+-----------+------------+-------+------------+---------------+---------------+
| networking  | elb - Load Balancer | us-west-2 | $43.92     | 2     | $21.96     |               |               |
+-------------+---------------------+-----------+------------+-------+------------+---------------+---------------+
| compute     | ec2-Admin-Cron Node | us-west-2 | $29.95     | 1     | $29.95     | t3            | medium        |
+-------------+---------------------+-----------+------------+-------+------------+---------------+---------------+
| database    | ElastiCache-Redis   | us-west-2 | $24.48     | 1     | $24.48     | t3            | small         |
+-------------+---------------------+-----------+------------+-------+------------+---------------+---------------+
| compute     | ec2-Varnish         | us-west-2 | $29.95     | 1     | $29.95     | t3            | large         |
+-------------+---------------------+-----------+------------+-------+------------+---------------+---------------+
| analytics   | ElasticSearch       | us-west-2 | $12.96     | 1     | $12.96     | t2            | micro         |
+-------------+---------------------+-----------+------------+-------+------------+---------------+---------------+
| database    | RDS MySQL           | us-west-2 | $48.96     | 1     | $48.96     | t3            | medium        |
+-------------+---------------------+-----------+------------+-------+------------+---------------+---------------+
| storage     | EBS Storage 30Gb    | us-west-2 | $9.13      | 1     | $9.13      |               |               |
+-------------+---------------------+-----------+------------+-------+------------+---------------+---------------+
|             |                     | Total     | $269.55    |       |            |               |               |
+-------------+---------------------+-----------+------------+-------+------------+---------------+---------------+
```

# Why not Magento Cloud?
```
+-----------------------------------------+-------------------------------------------+
|              Magento Cloud              |               This Solution               |
+-----------------------------------------+-------------------------------------------+
| Manual scaling, requires prior notice,  | Unlimited Resource, scaling by rule,      |
| vertical scaling,                       | no performance degradation                |
| performance degradation during scaling  |                                           |
+-----------------------------------------+-------------------------------------------+
| Fastly CDN only                         | Completely CDN agnostic,                  |
|                                         |  works with Cloudflare, CloudFront        |
+-----------------------------------------+-------------------------------------------+
| Works only with Enterprise version M2   | Works with any version of Magento 1/2     |
+-----------------------------------------+-------------------------------------------+
| Expansive $2000-$10000 month +          | Paying only for AWS resources you used,   |
| Enterprise license                      | starting from 300$ months                 |
+-----------------------------------------+-------------------------------------------+
| Not Customizable                        | Fully Customizeble                        |
+-----------------------------------------+-------------------------------------------+
| Host only single Magento 2 CE           | Can host multiple project, web sites,     |
| installation                            | tech stacks, PHP, Node.JS, Python, Java;  |
|                                         | Magento 1/2, WordPres, Drupal, Joomla,    |
|                                         | Presta Shop, Open Cart, Laravel, Django   |
+-----------------------------------------+-------------------------------------------+
```

# Basic Deployment With CodeDeploy Example 

## Code and application deployment is beyond the scope of this repo. This repo for infrastructure provisioning only

AWS CodeDeploy is a managed deployment technology. It provides great features like rolling deployments, automatic rollback, and load balancer integration. It is technology agnostic and Amazon uses it to deploy everything. 

ASSUMING YOU ALREADY HAVE an AWS account and CodeDeploy setup

Here are the basic that we take on a deployment for M2 

Here is the appspec.yml file (https://docs.aws.amazon.com/codedeploy/latest/userguide/reference-appspec-file.html#appspec-reference-ecs)
```
version: 0.0
os: linux
hooks:
    BeforeInstall:
        - location: config_files/scripts/beforeInstall.bash
          runas: root
    AfterInstall:
        - location: config_files/scripts/afterInstall.bash
          runas: mage_user
        - location: config_files/scripts/moveToProduction.bash
          runas: root
        - location: config_files/scripts/cacheclean.bash
          runas: mage_user
```

Script to 'compile' magento on Deploy server - You pull and compile code to deploy server or build Docker container end after just push code to production using Code Deploy - fastest way 

```
cd production/build/public_html
git checkout .
git pull origin master
rm -rf var/cache/* var/page_cache/* var/composer_home/* var/tmp/*
php composer.phar update --no-interaction --no-progress --optimize-autoloader
bin/magento setup:upgrade
bin/magento setup:static-content:deploy -t Magento/backend
bin/magento setup:static-content:deploy en_US es_ES -a frontend
bin/magento setup:di:compile
# Make code files and directories read-only
echo "Setting directory base permissions to 0750"
find . -type d -exec chmod 0750 {} \;
echo "Setting file base permissions to 0640"
find . -type f -exec chmod 0640 {} \;
chmod o-rwx app/etc/env.php && chmod u+x bin/magento

# Compress source at shared directory
if [ ! -d /build ]; then
    mkdir -p /build
fi
tar -czvf /build/build.tar.gz . --exclude='./pub/media' --exclude='./.htaccess' --exclude='./.git' --exclude='./var/cache' --exclude='./var/composer_home' --exclude='./var/log' --exclude='./var/page_cache' --exclude='./var/import' --exclude='./var/export' --exclude='./var/report' --exclude='./var/backups' --exclude='./var/tmp' --exclude='./var/resource_config.json' --exclude='./var/.sample-data-state.flag' --exclude='./app/etc/config.php' --exclude='./app/etc/env.php'
```
Now you can deploy to your pre-configured group

```
sh ./compile.sh
aws deploy create-deployment \
--application-name AppMagento2 \
--deployment-config-name CodeDeployDefault.OneAtATime \
--deployment-group-name MyMagentoApp \
--description "Live Deployment" \
--s3-location bucket=mage-codedeploy,bundleType=zip,eTag=<tagname>,key=live-build2.zip
```

Create this script to show where you are in the deployment

show-deployment.sh

```
aws deploy get-deployment --deployment-id $1 --query "deploymentInfo.[status, creator]" --output text
```

File 'config_files/scripts/afterInstall.bash' should run setup:upgrade --keep-generated, nginx, php-fpm restart and similar stuff

Source (https://magento.stackexchange.com/questions/224198/magento-2-aws-automatic-codedeploy-via-github-webhook)

##How to Deploy With Docker 

Just run command in your codeDeploy script 

```
docker pull [OPTIONS] MAGENTO_IMAGE_NAME[:TAG|@DIGEST]

```
# Use DynamoDb with Magento 2

Magento out of the box has PHP Library to work with Dynamo DB. 

```
use Aws\DynamoDb\Exception\DynamoDbException;
use Aws\DynamoDb\Marshaler;

$sdk = new Aws\Sdk([
    'endpoint'   => 'http://localhost:8000',
    'region'   => 'us-west-2',
    'version'  => 'latest'
]);

$dynamodb = $sdk->createDynamoDb();
$marshaler = new Marshaler();

$tableName = 'Movies';

$year = 2015;
$title = 'The Big New Movie';

$item = $marshaler->marshalJson('
    {
        "year": ' . $year . ',
        "title": "' . $title . '",
        "info": {
            "plot": "Nothing happens at all.",
            "rating": 0
        }
    }
');

$params = [
    'TableName' => 'Movies',
    'Item' => $item
];

try {
    $result = $dynamodb->putItem($params);
    echo "Added item: $year - $title\n";

} catch (DynamoDbException $e) {
    echo "Unable to add item:\n";
    echo $e->getMessage() . "\n";
}

?>
```

You can logs records to a DynamoDB table with the AWS SDK and Monolog using /Monolog/Handler/DynamoDbHandler.php

When Time to Live (TTL) is enabled on a table in Amazon DynamoDB, a background job checks the TTL attribute of items to determine whether they are expired.

Also you can use the Amazon Web Services CloudWatch Logs Handler for Monolog library to integrate Magento 2 Monolog with CloudWatch Logs (https://github.com/maxbanton/cwh)

```
php composer.phar require maxbanton/cwh:^1.0
```


If you have any questions feel free to send me an email  – yegorshytikov@gmail.com	

