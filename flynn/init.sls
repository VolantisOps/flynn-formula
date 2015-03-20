{% from "flynn/map.jinja" import flynn as flynn_map with context %}
{% from "flynn/map.jinja" import flynn as flynn_map with context %}
{% set flynn = pillar.get('flynn', {}) -%}

/root/install-flynn:
  file.managed:
    - source: https://dl.flynn.io/install-flynn
    - source_hash: sha512=e8b4912dc8cf2562e9530ee4244f1fa753c1c6f4b19aa9464519658243aff5f50d68591a003e5c5f164812a513be946189788b4dcaa7f6bd094a3407e614be23
    - user: root
    - group: root
    - mode: 700
    

flynn:
  'bash /root/install-flynn':
    cmd:
      - run
      - onlyif: 'test ! -e /usr/local/bin/flynn-host'
      - require:
        - file: /root/install-flynn
#  service.running:
#    - name: {{ template.service }}
#    - enable: True
