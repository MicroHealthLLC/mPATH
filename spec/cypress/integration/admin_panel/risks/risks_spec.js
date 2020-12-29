describe('Admin Panel Risk', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.get('[data-cy=admin_panel]').click()
  })

  it('Click on Risks on tabs open Risk information page', function() {
    cy.get('#tabs').within(() => {
      cy.get('#risks').contains('Risks').click()
    })
    cy.get('#page_title').contains('Risks').should('be.visible')
    // cy.get('#index_table_risks').should('be.visible')
    cy.get('#logout').click()
  })
})
