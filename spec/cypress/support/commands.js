// Login command
Cypress.Commands.add("login", (email, password) => {
  cy.visit('/')
  cy.get('[data-cy=user_email]').type(email).should('have.value', email)
  cy.get('[data-cy=user_password]').type(password).should('have.value', password)
  cy.get('[data-cy=user_remember_me]').click()
  cy.get('[data-cy=submit]').click()
  cy.contains('Welcome to MicroHealth Geographical Information System')
})

// Logout Command
Cypress.Commands.add("logout", () => {
  cy.get('[data-cy=logout]').click()
  cy.contains('You need to sign in before continuing.')
})

// Open first Project
Cypress.Commands.add("openProject", () => {
  cy.get('[data-cy=project_list_items]').first().click()
  cy.wait(500)
  cy.get('[data-cy=facility_list]').contains('Facility Manager')
})

// Open first Facility of a project
Cypress.Commands.add("openFacility", () => {
  cy.openProject()
  cy.get('[data-cy=facilities]').first().click()
  cy.wait(50)
  cy.contains('Facility Summary')
})

// Open first Tasks List of a facility
Cypress.Commands.add("tasksList", () => {
  cy.openFacility()
  cy.get('[data-cy=facility_tabs]').contains('Tasks').click()
})

// Create new task under a facility
Cypress.Commands.add("createNewTask", () => {
  const start_date = Cypress.moment().add(1, 'day').format('DD MMM YYYY')
  const due_date = Cypress.moment().add(7, 'day').format('DD MMM YYYY')

  cy.get('[data-cy=new_task]').click()
  cy.contains('Task Name:')
  cy.get('[data-cy=new_task_name]').type('New test task').should('have.value', 'New test task')
  cy.get('[data-cy=new_task_description]').type('New test task description').should('have.value', 'New test task description')
  cy.get('[data-cy=new_task_type]').click().type('{enter}')
  cy.get('[data-cy=new_task_stage]').click().type('{enter}')

  cy.get('[data-cy=new_task_start_date]').type(`${start_date}{enter}`)
  cy.get('[data-cy=new_task_due_date]').type(`${due_date}{enter}`)

  cy.get('[data-cy=new_task_user]').click().type('{enter}')
  cy.get('[data-cy=task_save_btn]').should('not.be.disabled')
  cy.get('[data-cy=task_save_btn]').click()
})
