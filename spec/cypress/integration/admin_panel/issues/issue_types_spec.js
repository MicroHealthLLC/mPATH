describe('Admin Panel Issue Types', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.get('[data-cy=admin_panel]').click()
  })

  it('Click on Issue Types on tabs open Issue Type information page', function() {
    cy.get('#tabs').within(() => {
      cy.get('#issue_types').contains('Issue Types').click({force: true})
    })
    cy.get('#page_title').contains('Issue Types').should('be.visible')
    cy.get('#index_table_issue_types').should('be.visible')
    cy.get('#logout').click()
  })
})
