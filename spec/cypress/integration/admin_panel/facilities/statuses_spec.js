describe('Admin Panel Statuses', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.get('[data-cy=admin_panel]').click()
  })

  it('Click on Statuses on tabs open Project type information page', function() {
    cy.get('#tabs').within(() => {
      cy.get('#statuses').contains('Statuses').click({force: true})
    })
    cy.get('#page_title').contains('Statuses').should('be.visible')
    cy.get('#index_table_statuses').should('be.visible')
    cy.get('#logout').click()
  })
})
