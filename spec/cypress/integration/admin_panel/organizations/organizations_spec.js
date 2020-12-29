describe('Admin Panel Organization', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.get('[data-cy=admin_panel]').click()
  })

  it('Click on Organizations on tabs open Organization information page', function() {
    cy.get('#tabs').within(() => {
      cy.get('#organizations').contains('Organizations').click({force: true})
    })
    cy.get('#page_title').contains('Organizations').should('be.visible')
    cy.get('#index_table_organizations').should('be.visible')
    cy.get('#logout').click()
  })
})
