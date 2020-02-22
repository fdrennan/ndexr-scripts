library(biggr)
library(reticulate)

# install_python(envname = 'biggr')
use_virtualenv('biggr')

configure_aws(
  aws_access_key_id = 'AKIAWEUHS5ME466TPTBD',
  aws_secret_access_key = '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',
  default.region = 'us-east-2'
)


ec2_instance_info()

s3_list_buckets()

s3_download_file(
  'drenrdatasets',
  'cache.tar.gz',
  '/home/ubuntu/projects/overrider/cache.tar.gz'
)

# s3_downloads_file(
#   'drenstuff',
#   'oa1.tar.gz',
#   '/Users/fdrennan/r_projects/projects/oa.tar.gz'
# )
