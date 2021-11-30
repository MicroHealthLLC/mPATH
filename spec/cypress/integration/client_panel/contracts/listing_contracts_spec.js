describe('Contracts View', function() {
  before(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.appScenario('provide_all_privileges')
    cy.login('client@test.com', 'T3$tClient')
    cy.openFacilitySheet()
    // cy.get('#customtabs > :nth-child(3) > .badge').contains('Contracts').should('be.visible').click()
  })

  beforeEach(() => {
    cy.preserveAllCookiesOnce()
  })
  
  after(() => {
    cy.clearCookies()
  })

  it('Open Contracts in a facility', function() {
    cy.get('[data-cy=program_setting]').click()
    cy.get('[data-cy=contract_card]').click()
    cy.get('[data-cy=contracts_table]').should('be.visible')
    cy.get('[data-cy=contracts_table]').within(() => {
      cy.get('tr').first().should('be.exist').click({force: true})
      cy.get('tr').its('length').should('be.eq', 3) // Header + total row. It is because the plugin is creating two tables.
    })
    // cy.logout()
  })
})