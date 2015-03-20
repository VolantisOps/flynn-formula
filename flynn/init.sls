{% from "flynn/map.jinja" import flynn as flynn_map with context %}
{% from "flynn/map.jinja" import flynn as flynn_map with context %}
{% set flynn = pillar.get('flynn', {}) -%}

install-flynn:
  cmd:
    - name: 'curl -fsSL -o /root/install-flynn https://dl.flynn.io/install-flynn'
    - run
    - onlyif: 'test ! -e /root/install-flynn'

flynn:
  cmd:
    - name: 'bash /root/install-flynn'
    - run
    - onlyif: 'test ! -e /usr/local/bin/flynn-host'
    - require:
      - file: /root/install-flynn
