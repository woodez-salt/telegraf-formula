{% if grains['os_family'] == 'RedHat' %}

/etc/yum.repos.d/influxdata.repo:
  file.managed:
    - user: root
    - group: root
    - mode: 0644
    - source: salt://telegraf/files/influxdata.repo

{% else %}

install_script_file:
  file.managed:
    - user: root
    - group: root
    - name: /tmp/telegraf_ubuntu_repo.sh
    - mode: 0755
    - source: salt://telegraf/files/telegraf_ubuntu_repo.sh

run_setup:
  cmd.run:
    - name: /tmp/telegraf_ubuntu_repo.sh > /dev/null 2>&1

{% endif %}

telegraf_package:
  pkg.installed:
    - pkgs:
      - telegraf

telegraf_file:
  file.managed:
    - user: root
    - group: root
    - name: /etc/telegraf/telegraf.conf
    - mode: 0644
    - source: salt://telegraf/files/telegraf.conf

telegraf:
  service.running:
    - enable: True
    - reload: True
