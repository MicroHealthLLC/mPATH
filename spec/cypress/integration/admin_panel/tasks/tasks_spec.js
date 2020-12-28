describe('Admin Panel Task', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.get('[data-cy=admin_panel]').click()
  })

  it('Click on Tasks on tabs open Task information page', function() {
    cy.get('#tabs').within(() => {
      cy.get('#tasks').contains('Tasks').click()
    })
    cy.get('#page_title').contains('Tasks').should('be.visible')
    cy.get('#index_table_tasks').should('be.visible')
    cy.get('#logout').click()
  })
})
