Feature: Validar red VPC

  Scenario: VPC CIDR debe ser configurado correctamente
    Given I have aws_vpc defined
    Then it must contain cidr_block
    And the cidr_block must be a valid IP range
