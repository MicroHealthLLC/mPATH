describe('Admin Panel Facility', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.get('[data-cy=admin_panel]').click()
  })

  it('Click on Facilities on tabs open Facility information page', function() {
    cy.get('#tabs').within(() => {
      cy.get('#facilities').contains('Facilities').click()
    })
    cy.get('#page_title').contains('Facilities').should('be.visible')
    cy.get('#index_table_facilities').should('be.visible')
    cy.get('#logout').click()
  })
})
