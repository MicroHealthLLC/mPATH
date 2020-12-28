describe('Admin Panel Project', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.get('[data-cy=admin_panel]').click()
  })

  it('Click on Projects on tabs open Project information page', function() {
    cy.get('#tabs').within(() => {
      cy.get('#projects').contains('Projects').click()
    })
    cy.get('#page_title').contains('Projects').should('be.visible')
    cy.get('#index_table_projects').should('be.visible')
    cy.get('#logout').click()
  })
})
