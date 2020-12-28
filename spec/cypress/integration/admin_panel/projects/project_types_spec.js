describe('Admin Panel Project Types', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.get('[data-cy=admin_panel]').click()
  })

  it('Click on Project Types on tabs open Project Type information page', function() {
    cy.get('#tabs').within(() => {
      cy.get('#project_types').contains('Project Types').click({force: true})
    })
    cy.get('#page_title').contains('Project Types').should('be.visible')
    cy.get('#index_table_project_types').should('be.visible')
    cy.get('#logout').click()
  })
})
