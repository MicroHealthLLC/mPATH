describe('Admin Panel Users', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.get('[data-cy=admin_panel]').click()
  })

  it('Click on Users on tabs open users information page', function() {
    cy.get('#tabs').within(() => {
      cy.get('#users').contains('Users').click()
    })
    cy.get('#page_title').contains('Users').should('be.visible')
    cy.get('#index_table_users').should('be.visible')
    cy.get('#logout').click()
  })
})
