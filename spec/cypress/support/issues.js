// All Issues related commands

// Open Issues List of a facility
Cypress.Commands.add('issueList', () => {
  cy.openFacility()
  cy.get('[data-cy=facility_tabs]').contains('Issues').click()
})

// Create new issue under a facility
Cypress.Commands.add("createNewIssue", () => {
  const start_date = Cypress.moment().add(1, 'day').format('DD MMM YYYY')
  const due_date = Cypress.moment().add(7, 'day').format('DD MMM YYYY')

  cy.get('[data-cy=new_issue]').click()
  cy.contains('Issue Name:')
  cy.get('[data-cy=issue_title]').type('New test issue').should('have.value', 'New test issue')
  cy.get('[data-cy=issue_description]').type('New test issue description').should('have.value', 'New test issue description')
  cy.get('[data-cy=issue_type]').click().type('{enter}')
  cy.get('[data-cy=issue_severity]').click().type('{enter}')
  cy.get('[data-cy=issue_stage]').click().type('{enter}')

  cy.get('[data-cy=issue_start_date]').type(`${start_date}{enter}`)
  cy.get('[data-cy=issue_due_date]').type(`${due_date}{enter}`)

  cy.get('[data-cy=issue_user]').click().type('{enter}')
  cy.get('[data-cy=issue_save_btn]').should('not.be.disabled')
  cy.get('[data-cy=issue_save_btn]').click()
  cy.get('[data-cy=task_list]').contains('New test issue', {timeout: 60000}).should('be.visible')
})

// Open Kanban Isuues
Cypress.Commands.add("openKanbanIssue", () => {
  cy.openKanban()
  cy.get('[data-cy=facility_tabs]').within(() => {
    cy.contains('Kanban Issues').should('be.visible').click()
  })
})
