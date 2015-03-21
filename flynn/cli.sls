{% from "flynn/map.jinja" import flynn as flynn_map with context %}
{% set cli = pillar.get('flynn:cli', {}) -%}

flynn-cli:
  cmd:
    - name: 'L=/usr/local/bin/flynn && curl -sL -A "`uname -sp`" https://dl.flynn.io/cli | zcat >$L && chmod +x $L'
    - run
    - onlyif: 'test ! -e /usr/local/bin/flynn'