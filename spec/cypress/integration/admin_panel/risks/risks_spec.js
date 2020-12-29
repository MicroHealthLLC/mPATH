describe('Admin Panel Risk', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openRiskAP()
  })

  it('Click on Risks on tabs open Risk information page', function() {
    cy.get('#page_title').contains('Risks').should('be.visible')
    // cy.get('#index_table_risks').should('be.visible')
    cy.get('#index_table_risks').should('not.exist')
    cy.get('#logout').click()
  })
})
