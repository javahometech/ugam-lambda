resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.process_json_lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.ugam_feeds.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.ugam_feeds.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.process_json_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    # filter_prefix       = "AWSLogs/"
    filter_suffix       = ".json"
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}

data "archive_file" "lambda" {
  type        = "zip"
  source_file = "./scripts/processJSONFeeds.py"
  output_path = "./scripts/processJSONFeeds.zip"
}

resource "aws_lambda_function" "process_json_lambda" {
  filename      = data.archive_file.lambda.output_path
  function_name = "processJSONFeeds"
  role          = aws_iam_role.ugam_feed_lambda_role.arn
  handler       = "processJSONFeeds.lambda_handler"

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256(data.archive_file.lambda.output_path)

  runtime = "python3.8"
}