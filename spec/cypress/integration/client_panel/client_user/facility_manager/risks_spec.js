describe('Risks Page', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('client@test.com', 'T3$tClient')
    cy.risksList()
  })

  it('Open Risk list page of a Facility', function() {
    cy.get('[data-cy=risk_list]').should('be.visible')
    cy.get('[data-cy=risks]').its('length').should('be.eq', 2)
    cy.logout()
  })

  it('Cannot open new risk form and edit/delete existing risk', function() {
    cy.get('[data-cy=new_risk]').should('not.exist')
    cy.get('[data-cy=risks]').first().click()
    cy.contains('Risk Name:')
    cy.get('[data-cy=risk_read_only_btn]').should('be.disabled')
    cy.get('[data-cy=risk_delete_btn]').should('not.exist')
    cy.get('[data-cy=risk_close_btn]').click()
    cy.logout()
  })

  it('Search risk by typing title', function() {
    cy.get('[data-cy=risks]').its('length').should('be.eq', 2)
    cy.get('[data-cy=search_risks]').clear().type('Risk is not in the list').should('have.value', 'Risk is not in the list')
    cy.contains('No risks found..').should('be.visible')

    // cy.get('[data-cy=search_risks]').clear().type('Test Risk').should('have.value', 'Test Risk')
    // cy.get('[data-cy=risks]').its('length').should('be.eq', 1)

    cy.get('[data-cy=search_risks]').clear()
    cy.get('[data-cy=risks]').its('length').should('be.eq', 2)
    cy.logout()
  })
})
