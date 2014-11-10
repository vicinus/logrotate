define logrotate::rulepath (
  $rulebody = undef,
  $order = "01",
  $hourly = false,
  $path = undef,
) {

  if (is_array($path)) {
    $rpath = join($path, " ")
  } else {
    $rpath = $path
  }
  if ($hourly) {
    $rule_path = "/etc/logrotate.d/hourly/${rulebody}"
  } else {
    $rule_path = "/etc/logrotate.d/${rulebody}"
  }
  concat::fragment { $name:
    target => $rule_path,
    order => $order,
    content => "$rpath\n",
  }
}
