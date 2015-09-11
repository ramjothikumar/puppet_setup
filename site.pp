node default {
file {'/tmp/test1':
  ensure  => present,
  content => "Hello World!",
}
}
