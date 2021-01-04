describe('Admin Panel Organization', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openOrganization()
  })

  it('Click on Organizations on tabs open Organization information page', function() {
    cy.get('#page_title').contains('Organizations').should('be.visible')
    cy.get('#index_table_organizations').should('be.visible')
    cy.get('#index_table_organizations > tbody > tr').its('length').should('be.eq', 1)
    cy.get('#logout').click()
  })

  it('Open and close new Organization form', function() {
    cy.get('.action_item > a').contains('New Organization').click()
    cy.get('#page_title').contains('New Organization').should('be.visible')
    cy.get('.cancel > a').contains('Cancel').click()
    cy.get('#logout').click()
  })

  it('Create new Organization', function() {
    cy.get('.action_item > a').contains('New Organization').click()
    cy.get('#organization_title').type('New Test Organization').should('have.value', 'New Test Organization')
    cy.get('#organization_submit_action > input').contains('Create Organization').click()
    cy.get('.flashes').contains('Organization was successfully created.')
    cy.get('#index_table_organizations').should('be.visible')
    cy.get('#index_table_organizations > tbody > tr').its('length').should('be.eq', 2)
    cy.get('#logout').click()
  })
})
