<?php
$CONFIG = [
'config_is_read_only' => true,
'loglevel' => 0,
'dbtype' => 'pgsql',
'dbhost' => getenv('POSTGRES_HOST'),
'dbname' => getenv('POSTGRES_DB'),
'dbuser' => getenv('POSTGRES_USER'),
'dbpass' => getenv('POSTGRES_PASSWORD'),
'objectstore' => array(
    'class' => '\OC\Files\ObjectStore\S3',
    'arguments' => array(
      'bucket' => getenv('OBJECTSTORE_S3_BUCKET'),
      'region' => getenv('OBJECTSTORE_S3_REGION'),
      'hostname' => getenv('OBJECTSTORE_S3_HOST'),
      'port' => getenv('OBJECTSTORE_S3_PORT'),
      'sse_c_key' => getenv('OBJECTSTORE_S3_SSE_C_KEY'),
      'objectPrefix' => '',
      'verify_bucket_exists' => false,
    )
  ),
  'passwordsalt' => getenv('PASSWORDSALT'),
  'secret' => getenv('SECRET'),
  'trusted_domains' => [getenv('SUBDNS1')]
];

// $CONFIG = [
//   'config_is_read_only' => false,
//   'loglevel' => 0,
//   'dbtype' => 'pgsql',
//   'dbhost' => getenv('POSTGRES_HOST'),
//   'dbname' => getenv('POSTGRES_DB'),
//   'dbuser' => getenv('POSTGRES_USER'),
//   'dbpass' => getenv('POSTGRES_PASSWORD'),
//   'objectstore' => array(
//       'class' => '\OC\Files\ObjectStore\S3',
//       'arguments' => array(
//         'bucket' => getenv('OBJECTSTORE_S3_BUCKET'),
//         'region' => getenv('OBJECTSTORE_S3_REGION'),
//         'hostname' => getenv('OBJECTSTORE_S3_HOST'),
//         'port' => getenv('OBJECTSTORE_S3_PORT'),
//         'sse_c_key' => getenv('OBJECTSTORE_S3_SSE_C_KEY'),
//         'objectPrefix' => '',
//         'verify_bucket_exists' => false,
//       )
//     ),
//     'passwordsalt' => getenv('PASSWORDSALT'),
//     'secret' => getenv('SECRET'),
//     'trusted_domains' => [getenv('SUBDNS1')]
//   ];