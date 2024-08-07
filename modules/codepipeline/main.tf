
resource "aws_codepipeline" "terraform_pipeline" {

  name          = "${var.project_name}-pipeline"
  pipeline_type = "V2"
  role_arn      = var.codepipeline_role_arn
  tags          = var.tags

  artifact_store {
    location = var.s3_bucket_name
    type     = "S3"
    encryption_key {
      id   = var.kms_key_arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Download-Source"
      category         = "Source"
      owner            = "AWS"
      version          = "1"
      provider         = "CodeStarSourceConnection"
      namespace        = "SourceVariables"
      output_artifacts = ["SourceOutput"]
      run_order        = 1

      configuration = {
        ConnectionArn    = var.codestar_connection_arn
        FullRepositoryId = var.source_repo_id
        BranchName       = var.source_repo_branch
      }
    }
  }

  #  trigger {
  #    provider_type = "CodeStarSourceConnection"
  #    git_configuration {
  #      source_action_name = "TriggerAction"
  #      push {
  #        branches {
  #          includes = ["main"]
  #        }
  #      }
  #      #      pull_request {
  #      #        events = ["CLOSED"]
  #      #        branches {
  #      #          includes = ["main", "foobar"]
  #      #          excludes = ["feature/*", "issue/*"]
  #      #        }
  #      #      }
  #    }
  #  }

  dynamic "stage" {
    for_each = var.stages

    content {
      name = "Stage-${stage.value["name"]}"
      action {
        category         = stage.value["category"]
        name             = "Action-${stage.value["name"]}"
        owner            = stage.value["owner"]
        provider         = stage.value["provider"]
        input_artifacts  = [stage.value["input_artifacts"]]
        output_artifacts = [stage.value["output_artifacts"]]
        version          = "1"
        run_order        = index(var.stages, stage.value) + 2

        configuration = {
          ProjectName = stage.value["provider"] == "CodeBuild" ? "${var.project_name}-${stage.value["name"]}" : null
        }
      }
    }
  }

}