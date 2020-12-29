describe('Admin Panel Facility Group', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.get('[data-cy=admin_panel]').click()
  })

  it('Click on Facility Groups on tabs open facility Group information page', function() {
    cy.get('#tabs').within(() => {
      cy.get('#facility_groups').contains('Facility Groups').click({force: true})
    })
    cy.get('#page_title').contains('Facility Groups').should('be.visible')
    cy.get('#index_table_facility_groups').should('be.visible')
    cy.get('#logout').click()
  })
})
