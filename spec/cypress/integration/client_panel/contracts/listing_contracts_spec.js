describe('Contracts View', function() {
  before(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.appScenario('provide_all_privileges')
    cy.login('client@test.com', 'T3$tClient')
    cy.openFacilitySheet()
    cy.get('[data-cy=program_setting]').click()
    cy.get('[data-cy=contract_card]').click()
  })

  beforeEach(() => {
    cy.preserveAllCookiesOnce()
  })
  
  after(() => {
    cy.clearCookies()
  })

  it('Open Contracts in a program settings', function() {
    cy.get('[data-cy=contracts_table]').should('be.visible')
    cy.get('[data-cy=contracts_table]').within(() => {
      cy.get('tr').first().should('be.exist').click({force: true})
      cy.get('tr').its('length').should('be.eq', 3) // Header + total row. It is because the plugin is creating two tables.
    })
  })

  it('Update contract in program setting', function() {
    cy.get('[data-cy=contracts_table]').should('be.visible')
    cy.get('[data-cy=contracts_table]').within(() => {
      cy.get('[data-cy=contract_nickname]').first().should('be.exist').click({force: true}).type(" Update")
      cy.get('[data-cy=contract_save_btn]').first().should('be.exist').click({force: true})
    })
    cy.wait(1000)
    cy.reload()
    cy.get('[data-cy=contracts_table]').should('be.visible')
    cy.get('.el-table__body').within(() => {
      cy.get('tr').first().should('be.exist').click({force: true})
      cy.get('tr').its('length').should('be.eq', 2) // Header + total row. It is because the plugin is creating two tables.
      cy.get('[data-cy=contract_nickname]').first().should('have.value', 'Contract 2 Nickname Update')
      cy.get('[data-cy=contract_facility_group_name]').first().should('have.value', 'Test Facility Group 1')
    })
  })

  it('Add contract in program setting', function() {
    cy.get('[data-cy=add_contract_btn]').click()
    cy.get('[data-cy=contract_name]').type("New Contract 1")
    cy.get('[data-cy=contract_facility_group_select]').type("{downarrow}").type("{enter}")
    cy.get('[data-cy=save_contract_btn]').click()
    cy.get('[data-cy=close_contract_btn]').click()
    cy.get('[data-cy=contracts_table]').within(() => {
      cy.get('[data-cy=contract_nickname]').first().should('have.value', 'New Contract 1')
      cy.get('[data-cy=contract_facility_group_name]').first().should('have.value', 'Test Facility Group 1')
    })
  })

})