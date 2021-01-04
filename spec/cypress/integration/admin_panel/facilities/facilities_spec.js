describe('Admin Panel Facility', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openFacilityAP()
  })

  it('Click on Facilities on tabs open Facility information page', function() {
    cy.get('#page_title').contains('Facilities').should('be.visible')
    cy.get('#index_table_facilities').should('be.visible')
    cy.get('#index_table_facilities > tbody > tr').its('length').should('be.eq', 4)
    cy.get('#logout').click()
  })

  it('Open and close new Facility form', function() {
    cy.get('.action_item > a').contains('New Facility').click()
    cy.get('#page_title').contains('New Facility').should('be.visible')
    cy.get('.cancel > a').contains('Cancel').click()
    cy.get('#logout').click()
  })

  it('Delete Facility', function() {
    cy.get('#index_table_facilities').should('be.visible')
    cy.get('#index_table_facilities > tbody > tr').first().within(() => {
      cy.get('.col-actions').contains('Delete').click()
    })
    cy.get('.flashes').contains('Facility was successfully destroyed.').should('be.visible')
    cy.get('#index_table_facilities > tbody > tr').its('length').should('be.eq', 3)
    cy.get('#logout').click()
  })
})
