#!/bin/bash

###########################
# Author: Ayush Garg
# Date: 5th-May'2024
#
# Version: v1
#
# This script will report the AWS resource usage
###########################


set -x # Debug Script
set -e
set -o

# check if AWS CLI is installed
read -p "Do you have AWS CLI installed? (yes/no): " aws_cli_installed

if [[ $aws_cli_installed == "yes" ]]; then
	# Verify AWS CLI installation
	if ! command -v aws &> /dev/null; then
		echo "AWS CLI is not installed. Please install it to use this script."
		exit 1
	fi


	# AWS CLI is installed
	aws --version

	# Check if AWS CLI is configured
	aws_configured=$(aws configure get aws_access_key_id)

	if [[ -z "$aws_configured" ]]; then
		# AWS CLI is not configured
		echo "AWS CLI is not configured."
		read -p "Do you want to configure AWS CLI now? (yes/no): " configure_aws_cli


		if [[ $configure_aws_cli == "yes" ]]; then
			# Configure AWS CLI
			aws configure
		else
			echo "Exiting script. Please configure AWS CLI to use this script"
			exit 1
		fi
	fi

	# AWS S3
	# AWS EC2
	# AWS Lambda
	# AWS IAM Users

	# implement crontab and push to github


	# list s3 buckets
	echo "Print list of s3 buckets"
	aws s3 ls > resourceTracker

	# list EC2 instances
	echo "Print list of ec2 buckets"
	aws ec2 describe-instances | jq '.Reservations[].Instances[].InstanceId' >> resourceTracker

	# list lambda
	echo "Print list of lambda functions"
	aws lambda list-functions >> resourceTracker

	# list IAM Users
	echo "Print lsit of IAM USers"
	aws iam list-users >> resourceTracker

	
	# Prompt user to remove credentials
	read -p "Do you want to remove AWS CLI credentials from the system? (yes/no): " remove_credentials

	if [[ $remove_credentials == "yes" ]]; then
		rm ~/.aws/credentials ~/.aws/config
		echo "AWS CLI credentials has been removed from the system."
	fi

else
	echo "AWS CLI is not installed. Please install it to use this script."
fi

