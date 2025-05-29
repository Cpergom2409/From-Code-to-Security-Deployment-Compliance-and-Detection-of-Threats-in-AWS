Feature: Grupos de Seguridad

  Scenario: Permitir tráfico desde cualquier IP
    Given I have aws_security_group defined
    When it has cidr_blocks
    Then its value must contain "0.0.0.0/0"
