describe('Admin Panel Task Categories', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.get('[data-cy=admin_panel]').click()
  })

  it('Click on Task Categories on tabs open Task Category information page', function() {
    cy.get('#tabs').within(() => {
      cy.get('#task_types').contains('Task Categories').click({force: true})
    })
    cy.get('#page_title').contains('Task Categories').should('be.visible')
    cy.get('#index_table_task_types').should('be.visible')
    cy.get('#logout').click()
  })
})
