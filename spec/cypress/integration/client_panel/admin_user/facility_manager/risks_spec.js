// describe('Risks Page', function() {
//   beforeEach(() => {
//     cy.app('clean')
//     cy.appScenario('basic')
//     cy.login('admin@test.com', 'T3$tAdmin')
//     cy.risksList()
//   })

//   it('Open Risk list page of a Facility', function() {
//     cy.get('[data-cy=risk_list]').should('be.visible')
//     cy.get('[data-cy=risks]').its('length').should('be.eq', 2)
//     cy.logout()
//   })

//   it('Open/Close new Risk form', function() {
//     cy.get('[data-cy=new_risk]').click()
//     cy.contains('Risk Name:').should('be.visible')
//     cy.get('[data-cy=risk_save_btn]').should('be.disabled')
//     cy.get('[data-cy=risk_close_btn]').click()
//     cy.contains('Risk Name:').should('not.exist')
//     cy.logout()
//   })

//   it('Delete the risk from facility manager', function() {
//     cy.get('[data-cy=risks]').its('length').should('be.eq', 2)
//     cy.get('[data-cy=risks]').first().click()
//     cy.get('[data-cy=risk_delete_btn]').click()
//     cy.contains('No risks found..').should('not.exist')
//     cy.wait(1000)
//     cy.get('[data-cy=risks]').its('length').should('be.gt', 0)
//     cy.get('[data-cy=risks]').first().click()
//     cy.get('[data-cy=risk_delete_btn]').click()
//     cy.contains('No risks found..').should('be.visible')
//     cy.logout()
//   })

//   it('Update risk name in a Facility', function() {
//     cy.get('[data-cy=risks]').first().click()
//     cy.get('[data-cy=risk_name]').clear().type('Updated new test risk').should('have.value', 'Updated new test risk')
//     cy.get('[data-cy=risk_save_btn]').click()
//     cy.get('[data-cy=risk_list]').contains('Updated new test risk').should('be.visible')
//     cy.logout()
//   })

//   it("In Risk form if name's field empty, error message display and save button must be disabled", function() {
//     cy.get('[data-cy=risks]').first().click()
//     cy.get('[data-cy=risk_name]').clear()
//     cy.get('[data-cy=risk_name_error]').contains('The Risk Name field is required.').should('be.visible')
//     cy.get('[data-cy=risk_save_btn]').should('be.disabled')
//     cy.get('[data-cy=risk_close_btn]').click()
//     cy.logout()
//   })

//   it('In Risk form if risk description is empty, save button must be disabled', function() {
//     cy.get('[data-cy=risks]').first().click()
//     cy.get('[data-cy=risk_description]').click().clear()
//     cy.get('[data-cy=risk_description_error]').contains('The risk_description field is required.').should('be.visible')
//     cy.get('[data-cy=risk_save_btn]').should('be.disabled')
//     cy.get('[data-cy=risk_close_btn]').click()
//     cy.logout()
//   })

//   it('In Risk form if risk impact description is empty, save button must be disabled', function() {
//     cy.get('[data-cy=risks]').first().click()
//     cy.get('[data-cy=impact_description]').click().clear()
//     cy.get('[data-cy=impact_description_error]').contains('The impact_description field is required.').should('be.visible')
//     cy.get('[data-cy=risk_save_btn]').should('be.disabled')
//     cy.get('[data-cy=risk_close_btn]').click()
//     cy.logout()
//   })

//   it("In Risk form if start date is empty, display it's error plus due date field and save button must be disabled", function() {
//     cy.get('[data-cy=risks]').first().click()
//     cy.get('[data-cy=risk_start_date]').within(() =>{
//       cy.get('.mx-icon-clear').click({ force: true})
//     })
//     cy.get('[data-cy=risk_start_date_error]').scrollIntoView()
//     cy.get('[data-cy=risk_start_date_error]').contains('The Start Date field is required.').should('be.visible')
//     cy.get('[data-cy=risk_due_date]').within(() => {
//       cy.get('input').should('be.disabled')
//     })
//     cy.get('[data-cy=risk_save_btn]').should('be.disabled')
//     cy.get('[data-cy=risk_close_btn]').click()
//     cy.logout()
//   })

//   it("In Risk form if due date is empty, display it's error and save button must be disabled", function() {
//     cy.get('[data-cy=risks]').first().click()
//     cy.get('[data-cy=risk_due_date]').within(() =>{
//       cy.get('.mx-icon-clear').click({ force: true})
//     })
//     cy.get('[data-cy=risk_due_date_error]').scrollIntoView()
//     cy.get('[data-cy=risk_due_date_error]').contains('The Estimated Completion Date field is required.').should('be.visible')
//     cy.get('[data-cy=risk_save_btn]').should('be.disabled')
//     cy.get('[data-cy=risk_close_btn]').click()
//     cy.logout()
//   })

//   it('In Risk form if task category not selected, save button must be disabled', function() {
//     cy.get('[data-cy=risks]').first().click()
//     cy.get('[data-cy=risk_milestone]').click().type('{enter}')
//     cy.get('[data-cy=risk_save_btn]').should('be.disabled')
//     cy.get('[data-cy=risk_close_btn]').click()
//     cy.logout()
//   })

//   it('In Risk form if risk impact description is empty, save button must be disabled', function() {
//     cy.get('[data-cy=risks]').first().click()
//     cy.get('[data-cy=approach_description]').click().clear()
//     cy.get('[data-cy=approach_description_error]').contains('The approach_description field is required.').should('be.visible')
//     cy.get('[data-cy=risk_save_btn]').should('be.disabled')
//     cy.get('[data-cy=risk_close_btn]').click()
//     cy.logout()
//   })

//   it('Search risk by typing title', function() {
//     cy.get('[data-cy=risks]').its('length').should('be.eq', 2)
//     cy.get('[data-cy=search_risks]').clear().type('risk is not in the list').should('have.value', 'risk is not in the list')
//     cy.contains('No risks found..').should('be.visible')

//     // cy.get('[data-cy=search_risks]').clear().type('Test risk').should('have.value', 'Test risk')
//     // cy.get('[data-cy=risks]').its('length').should('be.eq', 1)

//     cy.get('[data-cy=search_risks]').clear()
//     cy.get('[data-cy=risks]').its('length').should('be.eq', 2)
//     cy.logout()
//   })
// })
