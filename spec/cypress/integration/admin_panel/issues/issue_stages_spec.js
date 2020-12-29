describe('Admin Panel Issue Stages', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.get('[data-cy=admin_panel]').click()
  })

  it('Click on Issue Stages on tabs open Issue Stage information page', function() {
    cy.get('#tabs').within(() => {
      cy.get('#issue_stages').contains('Issue Stages').click({force: true})
    })
    cy.get('#page_title').contains('Issue Stages').should('be.visible')
    cy.get('#index_table_issue_stages').should('be.visible')
    cy.get('#logout').click()
  })
})
