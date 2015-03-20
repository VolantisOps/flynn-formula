{% from "flynn/map.jinja" import cli as cli_map with context %}
{% set cli = pillar.get('flynn:cli', {}) -%}

flynn-cli:
  'L=/usr/local/bin/flynn && curl -sL -A "`uname -sp`" https://dl.flynn.io/cli | zcat >$L && chmod +x $L':
    cmd:
      - run
      - onlyif: 'test ! -e /usr/local/bin/flynn'