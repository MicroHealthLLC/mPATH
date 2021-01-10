describe('Admin Panel Risk', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openRiskAP()
  })

  it('Click on Risks on tabs open Risk information page', function() {
    cy.get('#page_title').contains('Risks').should('be.visible')
    cy.get('#index_table_risks').should('be.visible')
    cy.get('#index_table_risks > tbody > tr').its('length').should('be.eq', 6)
    cy.get('#logout').click()
  })

  it('Open and close new Risk form', function() {
    cy.get('.action_item > a').contains('New Risk').click()
    cy.get('#page_title').contains('New Risk').should('be.visible')
    cy.get('.cancel > a').contains('Cancel').click()
    cy.get('#logout').click()
  })

  // it('Create new Risk', function() {
  //   const start_date = Cypress.moment().add(1, 'day').format('YYYY-MM-DD')
  //   const due_date = Cypress.moment().add(7, 'day').format('YYYY-MM-DD')
  //   cy.get('.action_item > a').contains('New Risk').click()
  //   cy.get('#page_title').contains('New Risk').should('be.visible')
  //   cy.get('#risk_text').type('New Test Risk').should('have.value', 'New Test Risk')
  //   cy.get('#risk_risk_description').type('Risk description').should('have.value', 'Risk description')
  //   cy.get('#risk_impact_description').type('Risk impact description').should('have.value', 'Risk impact description')
  //   cy.get('#risk_start_date').type(`${start_date}{enter}`)
  //   cy.get('#risk_due_date').type(`${due_date}{enter}`)
  //   cy.get('#risk_risk_approach_description').type('Risk approach description').should('have.value', 'Risk approach description')
  //   cy.get('#risk_submit_action').contains('Create Risk').click()
  //   cy.get('.flashes').contains('Risk was successfully created.')
  //   cy.get('#index_table_risks > tbody > tr').its('length').should('be.eq', 7)
  //   cy.get('#logout').click()
  // })

  it('Delete Risk', function() {
    cy.get('#index_table_risks').should('be.visible')
    cy.get('#index_table_risks > tbody > tr').first().within(() => {
      cy.get('.col-actions').contains('Delete').click()
    })
    cy.get('.flashes').contains('Risk was successfully destroyed.').should('be.visible')
    cy.get('#index_table_risks > tbody > tr').its('length').should('be.eq', 5)
    cy.get('#logout').click()
  })

  it('Search Risk contains name', function() {
    cy.get('#q_text').type('Test Risk 1').should('have.value', 'Test Risk 1')
    cy.get('[type=submit]').first().contains('Filter').click()
    cy.get('#search_status_sidebar_section').scrollIntoView()
    cy.get('#search_status_sidebar_section').should('be.visible')
    cy.get('#search_status_sidebar_section > h3').contains('Search status:').should('be.visible')
    cy.get('h4').contains('Current filters:').should('be.visible')
    cy.get('.current_filter').contains('Name contains Test Risk 1').should('be.visible')
    cy.get('#index_table_risks > tbody > tr').its('length').should('be.eq', 1)
    cy.get('.clear_filters_btn').last().contains('Clear Filters').click()
    cy.get('#logout').click()
  })
})
