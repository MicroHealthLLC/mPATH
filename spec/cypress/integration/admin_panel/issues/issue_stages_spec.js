describe('Admin Panel Issue Stages', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.openIssueStageAP()
  })

  it('Click on Issue Stages on tabs open Issue Stage information page', function() {
    cy.get('#page_title').contains('Issue Stages').should('be.visible')
    cy.get('#index_table_issue_stages').should('be.visible')
    cy.get('#index_table_issue_stages > tbody > tr').its('length').should('be.eq', 2)
    cy.get('#logout').click()
  })

  it('Open and close new Issue Stage form', function() {
    cy.get('.action_item > a').contains('New Issue Stage').click()
    cy.get('#page_title').contains('New Issue Stage').should('be.visible')
    cy.get('.cancel > a').contains('Cancel').click()
    cy.get('#logout').click()
  })

  it('Create new Issue Stage', function() {
    cy.get('.action_item > a').contains('New Issue Stage').click()
    cy.get('#page_title').contains('New Issue Stage').should('be.visible')
    cy.get('#issue_stage_name').type('New Test Issue Stage')
    cy.get('#issue_stage_submit_action').contains('Create Issue stage').click()
    cy.get('.flashes').contains('Issue stage was successfully created.')
    cy.get('#index_table_issue_stages > tbody > tr').its('length').should('be.eq', 3)
    cy.get('#logout').click()
  })

  it('Could not Delete Issue stage of foreign constraint', function() {
    cy.get('#index_table_issue_stages').should('be.visible')
    cy.get('#index_table_issue_stages > tbody > tr').first().within(() => {
      cy.get('.col-actions').contains('Delete').click()
    })
    cy.get('.flashes').contains('Not able to delete this! Violates foreign key constraint.').should('be.visible')
    cy.get('#index_table_issue_stages > tbody > tr').its('length').should('be.eq', 2)
    cy.get('#logout').click()
  })

  it('Delete Issue Stage', function() {
    cy.get('.action_item > a').contains('New Issue Stage').click()
    cy.get('#issue_stage_name').type('New Test Issue Stage')
    cy.get('#issue_stage_submit_action').contains('Create Issue stage').click()
    cy.get('#index_table_issue_stages > tbody > tr').last().within(() => {
      cy.get('.col-actions').contains('Delete').click()
    })
    cy.get('.flashes').contains('Issue stage was successfully destroyed.').should('be.visible')
    cy.get('#index_table_issue_stages > tbody > tr').its('length').should('be.eq', 2)
    cy.get('#logout').click()
  })
})
