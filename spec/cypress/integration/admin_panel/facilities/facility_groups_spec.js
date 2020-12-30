describe('Admin Panel Facility Group', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openFacilityGroupAP()
  })

  it('Click on Facility Groups on tabs open facility Group information page', function() {
    cy.get('#page_title').contains('Facility Groups').should('be.visible')
    cy.get('#index_table_facility_groups').should('be.visible')
    cy.get('#index_table_facility_groups > tbody > tr').its('length').should('be.eq', 2)
    cy.get('#logout').click()
  })

  it('Open and close new Facility Group form', function() {
    cy.get('.action_item > a').contains('New Facility Group').click()
    cy.get('#page_title').contains('New Facility Group').should('be.visible')
    cy.get('.cancel > a').contains('Cancel').click()
    cy.get('#logout').click()
  })
})
