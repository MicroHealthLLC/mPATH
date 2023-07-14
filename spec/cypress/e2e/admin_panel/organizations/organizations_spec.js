describe('Admin Panel Organization', function() {
  before(() => {
    cy.cleanData()
    cy.appScenario('basic')

  })
  beforeEach(() => {
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openOrganization()
    cy.get('#tabs').within(() => {
      cy.get('#organizations').contains('Organizations').click({force: true})
    })
  })
  it('Click on Organizations on tabs open Organization information page', function() {
    cy.get('#page_title').contains('Organizations').should('be.visible')
    cy.get('#index_table_organizations').should('be.visible')
    cy.get('#index_table_organizations > tbody > tr').its('length').should('be.eq', 1)
    // cy.get('#logout').click()
  })

  it('Open and close new Organization form', function() {
    cy.get('.action_item > a').contains('New Organization').click()
    cy.get('#page_title').contains('New Organization').should('be.visible')
    cy.get('.cancel > a').contains('Cancel').click()
    // cy.get('#logout').click()
  })

  it('Create new Organization', function() {
    cy.get('.action_item > a').contains('New Organization').click()
    cy.get('#organization_title').type('1 New Test Organization').should('have.value', '1 New Test Organization')
    cy.get('#organization_submit_action > input').contains('Create Organization').click()
    cy.get('.flashes').contains('Organization was successfully created.')
    cy.get('#index_table_organizations').should('be.visible')
    cy.get('#index_table_organizations > tbody > tr').its('length').should('be.eq', 2)
    // cy.get('#logout').click()
  })

  it('Sort Organization according to Title', function() {
    cy.get('.sortable').contains('Title').click()
    cy.get('#index_table_organizations > tbody > tr').first().contains('Test Organization').should('be.visible')
    cy.get('.sortable').contains('Title').click()
    cy.get('#index_table_organizations > tbody > tr').first().contains('1 New Test Organization').should('be.visible')
    // cy.get('#logout').click()
  })

  it('Search Organization contains name', function() {
    cy.get('#q_title').type('1 New Test Organization').should('have.value', '1 New Test Organization')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#search_status_sidebar_section').should('be.visible')
    cy.get('#search_status_sidebar_section > h3').contains('Search status:').should('be.visible')
    cy.get('h4').contains('Current filters:').should('be.visible')
    cy.get('.current_filter').contains('Title contains 1 New Test Organization').should('be.visible')
    cy.get('#index_table_organizations > tbody > tr').its('length').should('be.eq', 1)
    cy.get('.clear_filters_btn').last().contains('Clear Filters').click()
    // cy.get('#logout').click()
  })
  
  it('Delete Organization', function() {
    cy.get('#index_table_organizations').should('be.visible')
    cy.get('#index_table_organizations > tbody > tr').first().within(() => {
      cy.get('.col-actions').contains('Delete').click()
    })
    cy.get('.flashes').contains('Organization was successfully destroyed.').should('be.visible')
    // cy.get('#logout').click()
  })

})
