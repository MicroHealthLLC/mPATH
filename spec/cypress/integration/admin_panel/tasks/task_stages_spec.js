describe('Admin Panel Task Stages', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.get('[data-cy=admin_panel]').click()
  })

  it('Click on Task Stages on tabs open Task Stage information page', function() {
    cy.get('#tabs').within(() => {
      cy.get('#task_stages').contains('Task Stages').click({force: true})
    })
    cy.get('#page_title').contains('Task Stages').should('be.visible')
    cy.get('#index_table_task_stages').should('be.visible')
    cy.get('#logout').click()
  })
})
