describe('Admin Panel Issue', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.get('[data-cy=admin_panel]').click()
  })

  it('Click on Issues on tabs open Issue information page', function() {
    cy.get('#tabs').within(() => {
      cy.get('#issues').contains('Issues').click()
    })
    cy.get('#page_title').contains('Issues').should('be.visible')
    cy.get('#index_table_issues').should('be.visible')
    cy.get('#logout').click()
  })
})
