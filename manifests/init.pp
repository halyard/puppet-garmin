# @summary Configure Grafana importer instance
#
# @param token_dir sets the location for persistent token storage
# @param influxdb_host sets the influx host
# @param influxdb_username sets the influx username
# @param influxdb_password sets the influx password
# @param influxdb_database sets the influx database name
# @param influxdb_port sets the port to connect to influx
# @param container_ip sets the address of the Docker container
class garmin (
  String $token_dir,
  String $influxdb_host,
  String $influxdb_username,
  String $influxdb_password,
  String $influxdb_database = 'garmin',
  Integer $influxdb_port = 8086,
  String $container_ip = '172.17.0.3',
) {
  file { $token_dir:
    ensure => directory,
  }

  -> docker::container { 'garmin':
    image => 'thisisarpanghosh/garmin-fetch-data:latest',
    args  => [
      "--ip ${container_ip}",
      "-v ${token_dir}:/home/appuser/.garminconnect",
      "-e INFLUXDB_HOST=${influxdb_host}",
      "-e INFLUXDB_PORT=${influxdb_port}",
      "-e INFLUXDB_USERNAME=${influxdb_username}",
      "-e INFLUXDB_PASSWORD=${influxdb_password}",
      "-e INFLUXDB_DATABASE=${influxdb_database}",
    ],
    cmd   => '',
  }
}
