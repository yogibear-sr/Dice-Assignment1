provider "aws" {
  region = "us-east-2"
}

resource "aws_iam_role" "role" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


# Created Policy for IAM Role (s3 and log access)
resource "aws_iam_policy" "policy" {
  name = "my-s3cw--policy"
  description = "Access S3 and Cloudwatch logs policy"


  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:PutLogEvents",
                "logs:CreateLogGroup",
                "logs:CreateLogStream"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": "arn:aws:s3:::roll-the-dice0123456789/*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::roll-the-dice0123456789/*"
        }
    ]
}
EOF
}

# Attached IAM Role and the new created Policy
resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = "${aws_iam_role.role.name}"
  policy_arn = "${aws_iam_policy.policy.arn}"
}

resource "aws_s3_bucket" "onebucket" {
   bucket = "${var.bucketname}"
   acl = "private"

   tags = {
     Name = "Roll The Dice"
   }
}

# generate archive file

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "roll_dice.py"
  output_path = "RollDice.zip"
}

resource "aws_lambda_function" "test_lambda" {
  filename      = "RollDice.zip"
  description   = "Dice Rolling Simulation"
  function_name = "roll_dice"
  role          = "${aws_iam_role.role.arn}"
  handler       = "roll_dice.lambda_handler"
  source_code_hash = "${data.archive_file.lambda_zip.output_base64sha256}"

  runtime = "python3.8"

}
