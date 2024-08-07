project_name               = "obi-iac"
environment                = "dev"
source_repo_connection_arn = "arn:aws:codeconnections:eu-central-1:058264153756:connection/2fa2ed0c-0d42-4730-aaac-8b8453acbf44"
source_repo_id             = "jjankovi/obi-iac"
source_repo_branch         = "main"


stage_input = [
  { name = "validate", category = "Test", owner = "AWS", provider = "CodeBuild", input_artifacts = "SourceOutput", output_artifacts = "ValidateOutput" }
  #  { name = "plan", category = "Test", owner = "AWS", provider = "CodeBuild", input_artifacts = "ValidateOutput", output_artifacts = "PlanOutput" }
  #  { name = "apply", category = "Build", owner = "AWS", provider = "CodeBuild", input_artifacts = "PlanOutput", output_artifacts = "ApplyOutput" },
  #  { name = "destroy", category = "Build", owner = "AWS", provider = "CodeBuild", input_artifacts = "ApplyOutput", output_artifacts = "DestroyOutput" }
]
build_projects = ["validate"]

#build_projects = ["validate", "plan", "apply", "destroy"]

# these variables have default values
#builder_compute_type
#builder_image
#builder_type
#builder_image_pull_credentials_type
#build_project_source
