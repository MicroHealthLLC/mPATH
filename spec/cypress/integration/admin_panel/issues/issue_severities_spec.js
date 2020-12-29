describe('Admin Panel Issue Severities', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.get('[data-cy=admin_panel]').click()
  })

  it('Click on Issue Severities on tabs open Issue Severity information page', function() {
    cy.get('#tabs').within(() => {
      cy.get('#issue_severities').contains('Issue Severities').click({force: true})
    })
    cy.get('#page_title').contains('Issue Severities').should('be.visible')
    cy.get('#index_table_issue_severities').should('be.visible')
    cy.get('#logout').click()
  })
})
