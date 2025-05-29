Feature: Validar red VPC

  Scenario: La VPC tiene el bloque CIDR correcto
    Given I have aws_vpc defined
    Then it must contain cidr_block
    And its value must be "30.0.0.0/16"
