describe('Issue List', function() {
  beforeEach(() => {
    cy.app('clean')
    cy.appScenario('basic')
    cy.login('admin@test.com', 'T3$tAdmin')
    cy.issueList()
  })

  it('Open Issue list page of a Facility', function() {
    cy.get('[data-cy=issue_list]').should('be.visible')
    cy.get('[data-cy=issues]').its('length').should('be.eq', 2)
    cy.logout()
  })

  it('Open new Issue form', function() {
    cy.get('[data-cy=new_issue]').click()
    cy.contains('Issue Name:')
    cy.get('[data-cy=issue_save_btn]').should('be.disabled')
    cy.logout()
  })

  it('Close new Issue form', function() {
    cy.get('[data-cy=new_issue]').click()
    cy.contains('Issue Name:')
    cy.get('[data-cy=issue_close_btn]').click()
    cy.contains('Issue Name:').should('not.exist')
    cy.logout()
  })

  // it('Create new Issue in a Facility', function() {
  //   cy.createNewIssue()
  //   cy.get('[data-cy=issue_list]').contains('New test issue')
  //   cy.logout()
  // })

  it('Delete the Issue from facility manager', function() {
    cy.get('[data-cy=issues]').its('length').should('be.eq', 2)
    cy.get('[data-cy=issues]').first().click()
    cy.get('[data-cy=issue_delete_btn]').click()
    cy.contains('No issues found..').should('not.exist')
    cy.wait(1000)
    cy.get('[data-cy=issues]').its('length').should('be.eq', 1)
    cy.get('[data-cy=issues]').first().click()
    cy.get('[data-cy=issue_delete_btn]').click()
    cy.contains('No issues found..').should('be.visible')
    cy.logout()
  })

  it('Update issue name in a Facility', function() {
    cy.get('[data-cy=issues]').first().click()
    cy.get('[data-cy=issue_title]').clear().type('Updated new test issue').should('have.value', 'Updated new test issue')
    cy.get('[data-cy=issue_save_btn]').click()
    cy.get('[data-cy=issue_list]').contains('Updated new test issue').should('be.visible')
    cy.logout()
  })

  it("In Issue form if title's field empty, error message display and save button must be disabled", function() {
    cy.get('[data-cy=issues]').first().click()
    cy.get('[data-cy=issue_title]').clear()
    cy.get('[data-cy=issue_title_error]').contains('The title field is required.').should('be.visible')
    cy.get('[data-cy=issue_save_btn]').should('be.disabled')
    cy.get('[data-cy=issue_close_btn]').click()
    cy.logout()
  })

  it('In Issue form if issue type not selected, save button must be disabled', function() {
    cy.get('[data-cy=issues]').first().click()
    cy.get('[data-cy=issue_form]').within(() => {
      cy.get('[data-cy=issue_type]').click().type('{enter}')
      cy.get('[data-cy=issue_save_btn]').should('be.disabled')
      cy.get('[data-cy=issue_close_btn]').click()
    })
    cy.logout()
  })

  it('In Issue form if issue severity not selected, save button must be disabled', function() {
    cy.get('[data-cy=issues]').first().click()
    cy.get('[data-cy=issue_severity]').click().type('{enter}')
    cy.get('[data-cy=issue_save_btn]').should('be.disabled')
    cy.get('[data-cy=issue_close_btn]').click()
    cy.logout()
  })

  it("In Issue form if start date is empty, display it's error plus due date field and save button must be disabled", function() {
    cy.get('[data-cy=issues]').first().click()
    cy.get('[data-cy=issue_start_date]').within(() =>{
      cy.get('.mx-icon-clear').click({ force: true})
    })
    cy.get('[data-cy=issue_start_date_error]').scrollIntoView()
    cy.get('[data-cy=issue_start_date_error]').contains('The Start Date field is required.').should('be.visible')
    cy.get('[data-cy=issue_due_date]').within(() => {
      cy.get('input').should('be.disabled')
    })
    cy.get('[data-cy=issue_save_btn]').should('be.disabled')
    cy.get('[data-cy=issue_close_btn]').click()
    cy.logout()
  })

  it("In Issue form if due date is empty, display it's error and save button must be disabled", function() {
    cy.get('[data-cy=issues]').first().click()
    cy.get('[data-cy=issue_due_date]').within(() =>{
      cy.get('.mx-icon-clear').click({ force: true})
    })
    cy.get('[data-cy=issue_due_date_error]').scrollIntoView()
    cy.get('[data-cy=issue_due_date_error]').contains('The Estimated Completion Date field is required.').should('be.visible')
    cy.get('[data-cy=issue_save_btn]').should('be.disabled')
    cy.get('[data-cy=issue_close_btn]').click()
    cy.logout()
  })

  it('Search issue by typing title', function() {
    cy.get('[data-cy=issues]').its('length').should('be.eq', 2)
    cy.get('[data-cy=search_issues]').clear().type('Issue is not in the list').should('have.value', 'Issue is not in the list')
    cy.contains('No issues found..').should('be.visible')

    cy.get('[data-cy=search_issues]').clear().type('Test Issue').should('have.value', 'Test Issue')
    cy.get('[data-cy=issues]').its('length').should('be.eq', 1)

    cy.get('[data-cy=search_issues]').clear()
    cy.get('[data-cy=issues]').its('length').should('be.eq', 2)
    cy.logout()
  })

  // it('Select issue status from list to display related issues', function() {
  //   cy.get('[data-cy=issues]').its('length').should('be.eq', 2)
  //   cy.get('[data-cy=issue_status_list]').as('list')
  //   cy.get('@list').click()
  //   cy.get('@list').within(() => {
  //     cy.contains('complete').click()
  //   })
  //   cy.contains('No issues found..').should('be.visible')
  //   cy.get('@list').within(() => {
  //     cy.contains('all').click()
  //   })
  //   cy.get('[data-cy=issues]').its('length').should('be.eq', 2)
  //   cy.logout()
  // })
})
